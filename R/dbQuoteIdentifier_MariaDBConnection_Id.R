#' @name mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_Id <- function(conn, x, ...) {
  if (length(x@name) >= 3 && any(x@name[[length(x@name) - 2]] != "def")) {
    stop('If a "catalog" component is supplied in `Id()`, it must be equal to "def" everywhere.', call. = FALSE)
  }
  ids <- lapply(unname(x@name), function(x) dbQuoteIdentifier(conn, x))
  SQL(do.call(paste, c(ids, list(sep = "."))))
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "Id"), dbQuoteIdentifier_MariaDBConnection_Id)
