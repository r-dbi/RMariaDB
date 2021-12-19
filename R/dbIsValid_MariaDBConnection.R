# dbIsValid()
#' @rdname MariaDBConnection-class
#' @usage NULL
dbIsValid_MariaDBConnection <- function(dbObj, ...) {
  connection_valid(dbObj@ptr)
}

#' @rdname MariaDBConnection-class
#' @export
setMethod("dbIsValid", "MariaDBConnection", dbIsValid_MariaDBConnection)
