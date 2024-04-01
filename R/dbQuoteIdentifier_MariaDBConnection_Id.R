#' @name mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_Id <- function(conn, x, ...) {
  if (length(x@name) >= 3 && any(x@name[[length(x@name) - 2]] != "def")) {
    stop('If a "catalog" component is supplied in `Id()`, it must be equal to "def" everywhere.', call. = FALSE)
  }
  SQL(paste0(dbQuoteIdentifier(conn, x@name), collapse = "."))
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "Id"), dbQuoteIdentifier_MariaDBConnection_Id)
