#' @rdname mariadb-quoting
#' @usage NULL
dbQuoteLiteral_MariaDBConnection <- function(conn, x, ...) {
  # Switchpatching to avoid ambiguous S4 dispatch, so that our method
  # is used only if no alternatives are available.

  if (inherits(x, "difftime")) return(cast_difftime(callNextMethod()))

  callNextMethod()
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteLiteral", signature("MariaDBConnection"), dbQuoteLiteral_MariaDBConnection)
