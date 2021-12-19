#' @rdname result-meta
#' @usage NULL
dbHasCompleted_MariaDBResult <- function(res, ...) {
  result_has_completed(res@ptr)
}

#' @rdname result-meta
#' @export
setMethod("dbHasCompleted", "MariaDBResult", dbHasCompleted_MariaDBResult)
