#' @rdname result-meta
#' @usage NULL
dbGetRowCount_MariaDBResult <- function(res, ...) {
  result_rows_fetched(res@ptr)
}

#' @rdname result-meta
#' @export
setMethod("dbGetRowCount", "MariaDBResult", dbGetRowCount_MariaDBResult)
