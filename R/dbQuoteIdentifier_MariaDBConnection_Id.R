#' @name mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_Id <- function(conn, x, ...) {
  SQL(paste0(dbQuoteIdentifier(conn, x@name), collapse = "."))
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "Id"), dbQuoteIdentifier_MariaDBConnection_Id)
