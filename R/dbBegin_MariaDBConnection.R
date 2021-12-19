#' @name transactions
#' @usage NULL
dbBegin_MariaDBConnection <- function(conn, ...) {
  connection_begin_transaction(conn@ptr)
  invisible(TRUE)
}

#' @rdname transactions
#' @export
setMethod("dbBegin", "MariaDBConnection", dbBegin_MariaDBConnection)
