#' @rdname MariaDBDriver-class
#' @usage NULL
dbUnloadDriver_MariaDBDriver <- function(drv, ...) {
  TRUE
}

#' @rdname MariaDBDriver-class
setMethod("dbUnloadDriver", "MariaDBDriver", dbUnloadDriver_MariaDBDriver)
