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
#' @usage NULL
dbWriteTable_MariaDBConnection_character_character <- function(conn, name, value, field.types = NULL, overwrite = FALSE,
                                                               append = FALSE, header = TRUE, row.names = FALSE, nrows = 50,
                                                               sep = ",", eol = "\n", skip = 0, quote = '"', temporary = FALSE,
                                                               ...) {
  if (overwrite && append)
    stop("overwrite and append cannot both be TRUE", call. = FALSE)

  found <- dbExistsTable(conn, name)
  if (found && !overwrite && !append) {
    stop("Table ", name, " exists in database, and both overwrite and",
      " append are FALSE",
      call. = FALSE
    )
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
      d <- read.table(value,
        sep = sep, header = header, skip = skip,
        nrows = nrows, na.strings = "\\N", comment.char = "",
        stringsAsFactors = FALSE
      )
      field.types <- vapply(d, dbDataType,
        dbObj = conn,
        FUN.VALUE = character(1)
      )
    }

    sql <- sqlCreateTable(conn, name, field.types,
      row.names = row.names, temporary = temporary
    )
    dbExecute(conn, sql)
  }

  path <- normalizePath(value, winslash = "/", mustWork = TRUE)
  sql <- paste0(
    "LOAD DATA LOCAL INFILE ", dbQuoteString(conn, path), "\n",
    "INTO TABLE ", dbQuoteIdentifier(conn, name), "\n",
    "FIELDS TERMINATED BY ", dbQuoteString(conn, sep), "\n",
    "OPTIONALLY ENCLOSED BY ", dbQuoteString(conn, quote), "\n",
    "LINES TERMINATED BY ", dbQuoteString(conn, eol), "\n",
    "IGNORE ", skip + as.integer(header), " LINES"
  )

  dbExecute(conn, sql)

  invisible(TRUE)
}

#' @rdname mariadb-tables
#' @export
setMethod("dbWriteTable", c("MariaDBConnection", "character", "character"), dbWriteTable_MariaDBConnection_character_character)
