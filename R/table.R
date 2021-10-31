#' @include MariaDBConnection.R
NULL

#' Read and write MariaDB tables.
#'
#' These methods read or write entire tables from a MariaDB database.
#'
#' @return A data.frame in the case of `dbReadTable()`; otherwise a logical
#' indicating whether the operation was successful.
#' @note The data.frame returned by `dbReadTable()` only has
#' primitive data, e.g., it does not coerce character data to factors.
#' Temporary tables are ignored for `dbExistsTable()` and `dbListTables()` due to
#' limitations of the underlying C API. For this reason, a prior existence check
#' is performed only before creating a regular persistent table; an attempt to
#' create a temporary table with an already existing name will fail with a
#' message from the database driver.
#'
#'
#' @param conn a [MariaDBConnection-class] object, produced by
#'   [DBI::dbConnect()]
#' @param name a character string specifying a table name.
#' @param check.names If `TRUE`, the default, column names will be
#'   converted to valid R identifiers.
#' @inheritParams DBI::sqlRownamesToColumn
#' @param ... Unused, needed for compatibility with generic.
#' @examples
#' if (mariadbHasDefault()) {
#' con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#'
#' # By default, row names are written in a column to row_names, and
#' # automatically read back into the row.names()
#' dbWriteTable(con, "mtcars", mtcars[1:5, ], temporary = TRUE)
#' dbReadTable(con, "mtcars")
#' dbReadTable(con, "mtcars", row.names = FALSE)
#' }
#' @name mariadb-tables
NULL

#' @export
#' @rdname mariadb-tables
setMethod("dbReadTable", c("MariaDBConnection", "character"),
  function(conn, name, ..., row.names = FALSE, check.names = TRUE) {
    row.names <- compatRowNames(row.names)

    if ((!is.logical(row.names) && !is.character(row.names)) || length(row.names) != 1L)  {
      stopc("`row.names` must be a logical scalar or a string")
    }

    if (!is.logical(check.names) || length(check.names) != 1L)  {
      stopc("`check.names` must be a logical scalar")
    }

    name <- dbQuoteIdentifier(conn, name)
    out <- dbGetQuery(conn, paste("SELECT * FROM ", name),
      row.names = row.names)

    if (check.names) {
      names(out) <- make.names(names(out), unique = TRUE)
    }

    out
  }
)

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
#' @export
#' @rdname mariadb-tables
setMethod("dbWriteTable", c("MariaDBConnection", "character", "data.frame"),
  function(conn, name, value, field.types = NULL, row.names = FALSE,
           overwrite = FALSE, append = FALSE, ...,
           temporary = FALSE) {

    if (!is.data.frame(value))  {
      stopc("`value` must be data frame")
    }

    row.names <- compatRowNames(row.names)

    if ((!is.logical(row.names) && !is.character(row.names)) || length(row.names) != 1L)  {
      stopc("`row.names` must be a logical scalar or a string")
    }
    if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite))  {
      stopc("`overwrite` must be a logical scalar")
    }
    if (!is.logical(append) || length(append) != 1L || is.na(append))  {
      stopc("`append` must be a logical scalar")
    }
    if (!is.logical(temporary) || length(temporary) != 1L)  {
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
        stop("Table ", name, " exists in database, and both overwrite and",
          " append are FALSE", call. = FALSE)
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
      dbAppendTable(
        conn = conn,
        name = name,
        value = value
      )
    }

    if (need_transaction) {
      on.exit(NULL)
      dbCommit(conn)
    }

    invisible(TRUE)
  }
)

setMethod("sqlData", "MariaDBConnection", function(con, value, row.names = FALSE, ...) {
  value <- sql_data(value, con, row.names)
  value <- quote_string(value, con)

  value
})

#' @export
#' @rdname mariadb-tables
#' @importFrom utils read.table
#' @param sep field separator character
#' @param eol End-of-line separator
#' @param skip number of lines to skip before reading data in the input file.
#' @param quote the quote character used in the input file (defaults to
#'    `\"`.)
#' @param header logical, does the input file have a header line? Default is the
#'    same heuristic used by `read.table()`, i.e., `TRUE` if the first
#'    line has one fewer column that the second line.
#' @param nrows number of lines to rows to import using `read.table` from
#'   the input file to create the proper table definition. Default is 50.
setMethod("dbWriteTable", c("MariaDBConnection", "character", "character"),
  function(conn, name, value, field.types = NULL, overwrite = FALSE,
           append = FALSE, header = TRUE, row.names = FALSE, nrows = 50,
           sep = ",", eol = "\n", skip = 0, quote = '"', temporary = FALSE,
           ...) {

    if (overwrite && append)
      stop("overwrite and append cannot both be TRUE", call. = FALSE)

    found <- dbExistsTable(conn, name)
    if (found && !overwrite && !append) {
      stop("Table ", name, " exists in database, and both overwrite and",
        " append are FALSE", call. = FALSE)
    }
    if (found && overwrite) {
      dbRemoveTable(conn, name)
    }
    if (!found && append) {
      stop("Table ", name, " does not exists when appending")
    }

    if (!found || overwrite) {
      if (is.null(field.types)) {
        # Initialise table with first `nrows` lines
        d <- read.table(value, sep = sep, header = header, skip = skip,
          nrows = nrows, na.strings = "\\N", comment.char = "",
          stringsAsFactors = FALSE)
        field.types <- vapply(d, dbDataType, dbObj = conn,
          FUN.VALUE = character(1))
      }

      sql <- sqlCreateTable(conn, name, field.types,
        row.names = row.names, temporary = temporary)
      dbExecute(conn, sql)
    }

    path <- normalizePath(value, winslash = "/", mustWork = TRUE)
    sql <- paste0(
      "LOAD DATA LOCAL INFILE ", dbQuoteString(conn, path), "\n",
      "INTO TABLE ", dbQuoteIdentifier(conn, name), "\n",
      "FIELDS TERMINATED BY ", dbQuoteString(conn, sep), "\n",
      "OPTIONALLY ENCLOSED BY ", dbQuoteString(conn, quote), "\n",
      "LINES TERMINATED BY ", dbQuoteString(conn, eol), "\n",
      "IGNORE ", skip + as.integer(header), " LINES")

    dbExecute(conn, sql)

    invisible(TRUE)
  }
)

#' @export
#' @rdname mariadb-tables
setMethod("dbListTables", "MariaDBConnection", function(conn, ...) {
  # DATABASE(): https://stackoverflow.com/a/8096574/946850
  dbGetQuery(
    conn,
    paste0(
      "SELECT table_name FROM INFORMATION_SCHEMA.tables\n",
      "WHERE table_schema = DATABASE()"
    )
  )[[1]]
})


#' @export
#' @inheritParams DBI::dbListObjects
#' @rdname mariadb-tables
setMethod("dbListObjects", c("MariaDBConnection", "ANY"), function(conn, prefix = NULL, ...) {
  query <- NULL
  if (is.null(prefix)) {
    # DATABASE(): https://stackoverflow.com/a/8096574/946850
    query <- paste0(
      "SELECT NULL AS `schema`, table_name AS `table` FROM INFORMATION_SCHEMA.tables\n",
      "WHERE table_schema = DATABASE()\n",
      "UNION ALL\n",
      "SELECT DISTINCT table_schema AS `schema`, NULL AS `table` FROM INFORMATION_SCHEMA.tables"
    )
  } else {
    unquoted <- dbUnquoteIdentifier(conn, prefix)
    is_prefix <- vlapply(unquoted, function(x) { "schema" %in% names(x@name) && !("table" %in% names(x@name)) })
    schemas <- vcapply(unquoted[is_prefix], function(x) x@name[["schema"]])
    if (length(schemas) > 0) {
      schema_strings <- dbQuoteString(conn, schemas)
      query <- paste0(
        "SELECT table_schema AS `schema`, table_name AS `table` FROM INFORMATION_SCHEMA.tables\n",
        "WHERE ",
        "(table_schema IN (", paste(schema_strings, collapse = ", "), "))"
      )
    }
  }

  if (is.null(query)) {
    res <- data.frame(schema = character(), table = character(), stringsAsFactors = FALSE)
  } else {
    res <- dbGetQuery(conn, query)
  }

  is_prefix <- !is.na(res$schema) & is.na(res$table)
  tables <- Map(res$schema, res$table, f = as_table)

  ret <- data.frame(
    table = I(unname(tables)),
    is_prefix = is_prefix,
    stringsAsFactors = FALSE
  )
  ret
})

#' @export
#' @rdname mariadb-tables
setMethod("dbExistsTable", c("MariaDBConnection", "character"),
  function(conn, name, ...) {
    stopifnot(length(name) == 1L)
    if (!dbIsValid(conn)) {
      stopc("Invalid connection")
    }
    tryCatch({
      dbGetQuery(conn, paste0(
        "SELECT NULL FROM ", dbQuoteIdentifier(conn, name), " WHERE FALSE"
      ))
      TRUE
    }, error = function(...) {
      FALSE
    })
  }
)

#' @export
#' @rdname mariadb-tables
#' @param fail_if_missing If `FALSE`, `dbRemoveTable()` succeeds if the
#'   table doesn't exist.
setMethod("dbRemoveTable", c("MariaDBConnection", "character"),
  function(conn, name, ..., temporary = FALSE, fail_if_missing = TRUE) {
    extra <- list(...)

    name <- dbQuoteIdentifier(conn, name)
    dbExecute(
      conn,
      paste0(
        "DROP ",
        if (temporary) "TEMPORARY ",
        "TABLE ",
        if (!fail_if_missing) "IF EXISTS ",
        name
      )
    )
    invisible(TRUE)
  }
)

#' Determine the SQL Data Type of an S object
#'
#' This method is a straight-forward implementation of the corresponding
#' generic function.
#'
#' @param dbObj A [MariaDBDriver-class] or [MariaDBConnection-class] object.
#' @param obj R/S-Plus object whose SQL type we want to determine.
#' @param \dots any other parameters that individual methods may need.
#' @export
#' @rdname dbDataType
#' @examples
#' dbDataType(RMariaDB::MariaDB(), "a")
#' dbDataType(RMariaDB::MariaDB(), 1:3)
#' dbDataType(RMariaDB::MariaDB(), 2.5)
setMethod("dbDataType", "MariaDBConnection", function(dbObj, obj, ...) {
  dbDataType(MariaDB(), obj, ...)
})

#' @export
#' @rdname dbDataType
setMethod("dbDataType", "MariaDBDriver", function(dbObj, obj, ...) {
  if (is.factor(obj)) return(get_char_type(levels(obj)))
  if (inherits(obj, "POSIXct")) return("DATETIME(6)")
  if (inherits(obj, "Date")) return("DATE")
  if (inherits(obj, "difftime")) return("TIME(6)")
  if (inherits(obj, "integer64")) return("BIGINT")
  if (is.data.frame(obj)) return(callNextMethod(dbObj, obj))

  switch(typeof(obj),
    logical = "TINYINT", # works better than BIT(1), https://stackoverflow.com/q/289727/946850
    integer = "INTEGER",
    double = "DOUBLE",
    character = get_char_type(obj),
    list = "BLOB",
    stop("Unsupported type", call. = FALSE)
  )
})

get_char_type <- function(x) {
  width <- max(nchar(enc2utf8(x)), 1, na.rm = TRUE)
  if (width > 255) {
    "TEXT"
  } else {
    paste0("VARCHAR(", width, ")")
  }
}
