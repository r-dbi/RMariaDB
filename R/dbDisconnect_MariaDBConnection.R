# dbDisconnect()
#' @rdname MariaDBConnection-class
#' @usage NULL
dbDisconnect_MariaDBConnection <- function(conn, ...) {
  connection_release(conn@ptr)
  invisible(TRUE)
}

#' @rdname MariaDBConnection-class
#' @export
setMethod("dbDisconnect", "MariaDBConnection", dbDisconnect_MariaDBConnection)
