#' @rdname transactions
#' @usage NULL
dbCommit_MariaDBConnection <- function(conn, ...) {
  connection_commit(conn@ptr)
  invisible(TRUE)
}

#' @rdname transactions
#' @export
setMethod("dbCommit", "MariaDBConnection", dbCommit_MariaDBConnection)
