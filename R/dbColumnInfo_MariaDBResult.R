#' @name result-meta
#' @usage NULL
dbColumnInfo_MariaDBResult <- function(res, ...) {
  df <- result_column_info(res@ptr)
  df
}

#' @rdname result-meta
#' @export
setMethod("dbColumnInfo", "MariaDBResult", dbColumnInfo_MariaDBResult)
