#' @rdname transactions
#' @usage NULL
dbRollback_MariaDBConnection <- function(conn, ...) {
  connection_rollback(conn@ptr)
  invisible(TRUE)
}

#' @rdname transactions
#' @export
setMethod("dbRollback", "MariaDBConnection", dbRollback_MariaDBConnection)
