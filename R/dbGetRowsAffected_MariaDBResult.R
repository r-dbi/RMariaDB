#' @rdname result-meta
#' @usage NULL
dbGetRowsAffected_MariaDBResult <- function(res, ...) {
  result_rows_affected(res@ptr)
}

#' @rdname result-meta
#' @export
setMethod("dbGetRowsAffected", "MariaDBResult", dbGetRowsAffected_MariaDBResult)
