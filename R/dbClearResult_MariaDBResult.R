#' @rdname query
#' @usage NULL
dbClearResult_MariaDBResult <- function(res, ...) {
  if (!dbIsValid(res)) {
    warningc("Expired, result set already closed")
    return(invisible(TRUE))
  }
  result_release(res@ptr)
  invisible(TRUE)
}

#' @rdname query
#' @export
setMethod("dbClearResult", "MariaDBResult", dbClearResult_MariaDBResult)
