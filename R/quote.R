#' @include MariaDBConnection.R
NULL

#' Quote MariaDB strings and identifiers.
#'
#' In MariaDB, identifiers are enclosed in backticks, e.g. `` `x` ``.
#'
#' @keywords internal
#' @name mariadb-quoting
#' @examples
#' if (mariadbHasDefault()) {
#'   con <- dbConnect(RMariaDB::MariaDB())
#'   dbQuoteIdentifier(con, c("a b", "a`b"))
#'   dbQuoteString(con, c("a b", "a'b"))
#'   dbDisconnect(con)
#' }
NULL

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "character"),
  function(conn, x, ...) {
    if (any(is.na(x))) {
      stop("Cannot pass NA to dbQuoteIdentifier()", call. = FALSE)
    }
    x <- gsub("`", "``", x, fixed = TRUE)
    if (length(x) == 0L) {
      SQL(character(), names = names(x))
    } else {
      # Not calling encodeString() here to keep things simple
      SQL(paste("`", x, "`", sep = ""), names = names(x))
    }
  }
)

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "SQL"),
  function(conn, x, ...) {
    x
  }
)

#' @export
#' @rdname mariadb-quoting
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "Id"), function(conn, x, ...) {
  stopifnot(all(names(x@name) %in% c("schema", "table")))
  stopifnot(!anyDuplicated(names(x@name)))

  ret <- ""
  if ("schema" %in% names(x@name)) {
    ret <- paste0(ret, dbQuoteIdentifier(conn, x@name[["schema"]]), ".")
  }
  if ("table" %in% names(x@name)) {
    ret <- paste0(ret, dbQuoteIdentifier(conn, x@name[["table"]]))
  }
  SQL(ret)
})

#' @export
#' @rdname mariadb-quoting
setMethod("dbUnquoteIdentifier", c("MariaDBConnection", "SQL"), function(conn, x, ...) {
  rx <- '^(?:(?:|`((?:[^`]|``)+)`[.])(?:|`((?:[^`]|``)*)`)|([^`. ]+))$'
  bad <- grep(rx, x, invert = TRUE)
  if (length(bad) > 0) {
    stop("Can't unquote ", x[bad[[1]]], call. = FALSE)
  }
  schema <- gsub(rx, "\\1", x)
  schema <- gsub("``", "`", schema)
  table <- gsub(rx, "\\2", x)
  table <- gsub("``", "`", table)
  naked_table <- gsub(rx, "\\3", x)

  ret <- Map(schema, table, naked_table, f = as_table)
  names(ret) <- names(x)
  ret
})

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteString", c("MariaDBConnection", "character"),
  function(conn, x, ...) {
    SQL(connection_quote_string(conn@ptr, enc2utf8(x)))
  }
)

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteString", c("MariaDBConnection", "SQL"),
  function(conn, x, ...) {
    x
  }
)
