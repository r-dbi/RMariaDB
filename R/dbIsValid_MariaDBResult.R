#' @rdname MariaDBResult-class
#' @usage NULL
dbIsValid_MariaDBResult <- function(dbObj, ...) {
  result_valid(dbObj@ptr)
}

#' @rdname MariaDBResult-class
#' @export
setMethod("dbIsValid", "MariaDBResult", dbIsValid_MariaDBResult)
