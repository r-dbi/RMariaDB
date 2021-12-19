#' @rdname mariadb-quoting
#' @usage NULL
dbQuoteString_MariaDBConnection_character <- function(conn, x, ...) {
  SQL(connection_quote_string(conn@ptr, enc2utf8(x)))
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteString", c("MariaDBConnection", "character"), dbQuoteString_MariaDBConnection_character)
