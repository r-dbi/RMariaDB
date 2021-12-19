#' @rdname MariaDBDriver-class
#' @usage NULL
dbIsValid_MariaDBDriver <- function(dbObj, ...) {
  TRUE
}

#' @rdname MariaDBDriver-class
#' @export
setMethod("dbIsValid", "MariaDBDriver", dbIsValid_MariaDBDriver)
