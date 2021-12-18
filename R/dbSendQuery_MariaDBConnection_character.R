#' @rdname query
#' @usage NULL
dbSendQuery_MariaDBConnection_character <- function(conn, statement, params = NULL, ...) {
  dbSend(conn, statement, params, is_statement = FALSE)
}

#' @rdname query
#' @export
setMethod("dbSendQuery", c("MariaDBConnection", "character"), dbSendQuery_MariaDBConnection_character)
