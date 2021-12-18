#' @rdname mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_SQL <- function(conn, x, ...) {
  x
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "SQL"), dbQuoteIdentifier_MariaDBConnection_SQL)
