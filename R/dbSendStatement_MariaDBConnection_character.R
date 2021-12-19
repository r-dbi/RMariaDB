#' @rdname query
#' @usage NULL
dbSendStatement_MariaDBConnection_character <- function(conn, statement, params = NULL, ...) {
  dbSend(conn, statement, params, is_statement = TRUE)
}

#' @rdname query
#' @export
setMethod("dbSendStatement", signature("MariaDBConnection", "character"), dbSendStatement_MariaDBConnection_character)
