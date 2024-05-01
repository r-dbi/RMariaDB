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
#'   con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#'
#'   # By default, row names are written in a column to row_names, and
#'   # automatically read back into the row.names()
#'   dbWriteTable(con, "mtcars", mtcars[1:5, ], temporary = TRUE)
#'   dbReadTable(con, "mtcars")
#'   dbReadTable(con, "mtcars", row.names = FALSE)
#' }
#' @name mariadb-tables
NULL

db_append_table <- function(conn, name, value, warn_factor = TRUE, safe = TRUE, transact = TRUE) {
  path <- tempfile("RMariaDB", fileext = ".tsv")
  is_list <- vlapply(value, is.list)
  colnames <- dbQuoteIdentifier(conn, names(value))
  if (any(is_list)) {
    set <- paste0(
      "SET ",
      paste0(
        colnames[is_list], " = UNHEX(@X", which(is_list), ")",
        collapse = ", "
      )
    )
    colnames[is_list] <- paste0("@X", which(is_list))
  } else {
    set <- ""
  }

  quoted_name <- dbQuoteIdentifier(conn, name)
  if (length(quoted_name) != 1) {
    stop("Must pass one table name", call. = FALSE)
  }

  sql <- paste0(
    "LOAD DATA LOCAL INFILE ", dbQuoteString(conn, path), "\n",
    "IGNORE\n",
    "INTO TABLE ", quoted_name, "\n",
    "CHARACTER SET utf8mb4 \n",
    "(", paste0(colnames, collapse = ", "), ")",
    set
  )

  file <- file(path, "wb")
  on.exit(close(file))

  readr::write_delim(
    csv_quote(value, warn_factor, conn), file, quote = "none", delim = "\t", na = "\\N",
    col_names = FALSE
  )

  # Close connection manually, unlink when done to save disk space
  on.exit(unlink(path), add = FALSE)
  close(file)

  if (safe) {
    if (transact) {
      dbBegin(conn)
      on.exit(dbRollback(conn), add = TRUE)
    }

    sql_count <- paste0("SELECT COUNT(*) FROM ", quoted_name)
    count_before <- dbGetQuery(conn, sql_count)[[1]]

    out <- dbExecute(conn, sql)

    # Some servers don't return a record count here,
    # need to count manually
    if (out == 0) {
      count_after <- dbGetQuery(conn, sql_count)[[1]]
      out <- as.numeric(count_after - count_before)
    }

    if (transact) {
      if (out < nrow(value)) {
        stopc("Error writing table: sent ", nrow(value), " rows, added ", out, " rows.")
      }
      dbCommit(conn)
    }

    # Manual cleanup
    unlink(path)
    on.exit(NULL, add = FALSE)

    out
  } else {
    dbExecute(conn, sql)
  }
}

csv_quote <- function(x, warn_factor, conn) {
  old <- options(digits.secs = 6)
  on.exit(options(old))

  x[] <- lapply(x, csv_quote_one, conn)
  factor_to_string(x, warn = warn_factor)
}

csv_quote_one <- function(x, conn) {
  if (inherits(x, "AsIs")) {
    class(x) <- setdiff(class(x), "AsIs")
  }

  if (is.factor(x)) {
    levels(x) <- csv_quote_char(levels(x))
  } else if (is.character(x)) {
    x <- csv_quote_char(x)
  } else if (is.integer(x)) {
    x_orig <- x
    x <- as.character(x)
    # Failure to load BIT(1) columns with a verbatim 0 (???)
    # https://stackoverflow.com/a/17836602/946850
    x[!is.na(x_orig) & x_orig == 0] <- ""
  } else if (is.integer64(x)) {
    x_orig <- x
    x <- as.character(x)
    # Failure to load BIT(1) columns with a verbatim 0 (???)
    # https://stackoverflow.com/a/17836602/946850
    x[!is.na(x_orig) & x_orig == 0] <- ""
  } else if (is.numeric(x)) {
    x_orig <- x
    if (all_integerish(x)) {
      x <- formatC(x, format = "d")
    } else {
      # https://dev.mysql.com/doc/refman/5.7/en/number-literals.html
      x <- formatC(x, digits = 17, format = "E")
    }
    x[is.na(x_orig) | is.infinite(x_orig)] <- NA_character_
  } else if (is.logical(x)) {
    x <- as.character(as.integer(x))
  } else if (inherits(x, "Date")) {
    x <- as.character(x)
  } else if (inherits(x, "difftime")) {
    x <- hms::as_hms(x)
    x <- as.character(x)
  } else if (inherits(x, "POSIXt")) {
    x <- format(x, format = "%Y-%m-%dT%H:%M:%OS", tz = conn@timezone)
  } else if (inherits(x, "list")) {
    x_orig <- x
    x <- vcapply(x, function(x) paste(format(x), collapse = ""))
    x[vlapply(x_orig, is.null)] <- NA_character_
  } else {
    stop("NYI: ", paste(class(x), collapse = "/"), call. = FALSE)
  }

  x
}

csv_quote_char <- function(x) {
  x <- enc2utf8(x)
  x <- gsub("\\", "\\\\", x, fixed = TRUE)
  x <- gsub("\t", "\\t", x, fixed = TRUE)
  x <- gsub("\r", "\\r", x, fixed = TRUE)
  x <- gsub("\n", "\\n", x, fixed = TRUE)
  x
}

all_integerish <- function(x) {
  x <- x[!is.na(x)]
  if (any(is.infinite(x))) {
    return(FALSE)
  }
  all(x >= -2147483647) && all(x <= 2147483647) && all(x == as.integer(x))
}

get_char_type <- function(x) {
  width <- max(nchar(enc2utf8(x)), 1, na.rm = TRUE)
  if (width > 255) {
    "TEXT"
  } else {
    paste0("VARCHAR(", width, ")")
  }
}
