#' @name query
#' @usage NULL
dbBind_MariaDBResult <- function(res, params, ...) {
  if (!is.null(names(params))) {
    stopc("Cannot use named parameters for anonymous placeholders")
  }

  params <- sql_data(as.list(params), res@conn, warn = TRUE)

  result_bind(res@ptr, params)
  invisible(res)
}

#' @rdname query
#' @export
setMethod("dbBind", "MariaDBResult", dbBind_MariaDBResult)
