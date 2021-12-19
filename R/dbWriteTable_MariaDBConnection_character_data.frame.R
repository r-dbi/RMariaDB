#' @inheritParams DBI::sqlRownamesToColumn
#' @param overwrite a logical specifying whether to overwrite an existing table
#'   or not. Its default is `FALSE`.
#' @param append a logical specifying whether to append to an existing table
#'   in the DBMS.  If appending, then the table (or temporary table)
#'   must exist, otherwise an error is reported. Its default is `FALSE`.
#' @param value A data frame.
#' @param field.types Optional, overrides default choices of field types,
#'   derived from the classes of the columns in the data frame.
#' @param temporary If `TRUE`, creates a temporary table that expires
#'   when the connection is closed. For `dbRemoveTable()`, only temporary
#'   tables are considered if this argument is set to `TRUE`.
#' @rdname mariadb-tables
#' @usage NULL
dbWriteTable_MariaDBConnection_character_data.frame <- function(conn, name, value, field.types = NULL, row.names = FALSE,
                                                                overwrite = FALSE, append = FALSE, ...,
                                                                temporary = FALSE) {
  if (!is.data.frame(value)) {
    stopc("`value` must be data frame")
  }

  row.names <- compatRowNames(row.names)

  if ((!is.logical(row.names) && !is.character(row.names)) || length(row.names) != 1L) {
    stopc("`row.names` must be a logical scalar or a string")
  }
  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    stopc("`overwrite` must be a logical scalar")
  }
  if (!is.logical(append) || length(append) != 1L || is.na(append)) {
    stopc("`append` must be a logical scalar")
  }
  if (!is.logical(temporary) || length(temporary) != 1L) {
    stopc("`temporary` must be a logical scalar")
  }
  if (overwrite && append) {
    stopc("overwrite and append cannot both be TRUE")
  }
  if (!is.null(field.types) && !(is.character(field.types) && !is.null(names(field.types)) && !anyDuplicated(names(field.types)))) {
    stopc("`field.types` must be a named character vector with unique names, or NULL")
  }
  if (append && !is.null(field.types)) {
    stopc("Cannot specify `field.types` with `append = TRUE`")
  }

  need_transaction <- !connection_is_transacting(conn@ptr)
  if (need_transaction) {
    dbBegin(conn)
    on.exit(dbRollback(conn))
  }

  if (!temporary) {
    found <- dbExistsTable(conn, name)
    if (found && !overwrite && !append) {
      stopc(
        "Table ", name, " exists in database, and both overwrite and",
        " append are FALSE"
      )
    }
  } else {
    found <- FALSE
  }

  if (overwrite) {
    dbRemoveTable(conn, name, temporary = temporary, fail_if_missing = FALSE)
  }

  # dbAppendTable() calls sql_data(), we only need to take care of row names
  row.names <- compatRowNames(row.names)
  value <- sqlRownamesToColumn(value, row.names)
  value <- factor_to_string(value)

  if (!found || overwrite) {
    if (is.null(field.types)) {
      combined_field_types <- lapply(value, dbDataType, dbObj = conn)
    } else {
      combined_field_types <- rep("", length(value))
      names(combined_field_types) <- names(value)
      field_types_idx <- match(names(field.types), names(combined_field_types))
      stopifnot(!any(is.na(field_types_idx)))
      combined_field_types[field_types_idx] <- field.types
      values_idx <- setdiff(seq_along(value), field_types_idx)
      combined_field_types[values_idx] <- lapply(value[values_idx], dbDataType, dbObj = conn)
    }

    dbCreateTable(
      conn = conn,
      name = name,
      fields = combined_field_types,
      temporary = temporary
    )
  }

  if (nrow(value) > 0) {
    if (conn@load_data_local_infile) {
      out <- db_append_table(
        conn = conn,
        name = name,
        value = value,
        warn_factor = FALSE,
        safe = TRUE,
        transact = FALSE
      )
    } else {
      out <- dbAppendTable(
        conn = conn,
        name = name,
        value = value
      )
    }

    if (out < nrow(value)) {
      msg <- paste0("Error writing table: sent ", nrow(value), " rows, added ", out, " rows.")
      if (need_transaction) {
        stopc(msg)
      } else {
        warningc(msg)
      }
    }
  }

  if (need_transaction) {
    on.exit(NULL)
    dbCommit(conn)
  }

  invisible(TRUE)
}

#' @rdname mariadb-tables
#' @export
setMethod("dbWriteTable", c("MariaDBConnection", "character", "data.frame"), dbWriteTable_MariaDBConnection_character_data.frame)
