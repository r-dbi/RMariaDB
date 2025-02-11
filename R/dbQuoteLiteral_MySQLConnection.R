#' @name mysql-quoting
#' @usage NULL
dbQuoteLiteral_MySQLConnection <- function(conn, x, ...) {
  # Switchpatching to avoid ambiguous S4 dispatch, so that our method
  # is used only if no alternatives are available.

  if (inherits(x, "POSIXt")) {
    return(dbQuoteString(
      conn,
      strftime(as.POSIXct(x), "%Y%m%d%H%M%S", tz = "UTC")
    ))
  }
  callNextMethod()
}

#' @rdname mysql-quoting
#' @export
setMethod("dbQuoteLiteral", signature("MySQLConnection"), dbQuoteLiteral_MySQLConnection)
