#' @name mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_Id <- function(conn, x, ...) {
  unqouted_name <- x@name
  if (length(unqouted_name) == 3 && unqouted_name[[1]] == "def") {
    unqouted_name <- unqouted_name[-1]
  }

  SQL(paste0(dbQuoteIdentifier(conn, unqouted_name), collapse = "."))
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "Id"), dbQuoteIdentifier_MariaDBConnection_Id)
