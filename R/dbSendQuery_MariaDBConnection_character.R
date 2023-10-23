#' @rdname query
#' @usage NULL
dbSendQuery_MariaDBConnection_character <- function(conn, statement, params = NULL, ..., immediate = FALSE) {
  # immediate = TRUE not supported
  # Can't raise a warning here due to a test in DBItest
  dbSend(conn, statement, params, is_statement = FALSE, immediate = FALSE)
}

#' @rdname query
#' @export
setMethod("dbSendQuery", c("MariaDBConnection", "character"), dbSendQuery_MariaDBConnection_character)
