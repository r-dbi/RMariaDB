#' @rdname query
#' @usage NULL
dbSendStatement_MariaDBConnection_character <- function(conn, statement, params = NULL, ..., immediate = FALSE) {
  dbSend(conn, statement, params, is_statement = TRUE, immediate)
}

#' @rdname query
#' @export
setMethod("dbSendStatement", signature("MariaDBConnection", "character"), dbSendStatement_MariaDBConnection_character)
