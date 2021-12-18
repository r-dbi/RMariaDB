#' @rdname mariadb-quoting
#' @usage NULL
dbQuoteString_MariaDBConnection_SQL <- function(conn, x, ...) {
  x
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteString", c("MariaDBConnection", "SQL"), dbQuoteString_MariaDBConnection_SQL)
