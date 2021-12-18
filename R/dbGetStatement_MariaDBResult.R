#' @rdname query
#' @usage NULL
dbGetStatement_MariaDBResult <- function(res, ...) {
  if (!dbIsValid(res)) {
    stopc("Expired, result set already closed")
  }
  res@sql
}

#' @rdname query
#' @export
setMethod("dbGetStatement", "MariaDBResult", dbGetStatement_MariaDBResult)
