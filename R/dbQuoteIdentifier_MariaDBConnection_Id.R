#' @name mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_Id <- function(conn, x, ...) {
  components <- c("schema", "table", "column")
  stopifnot(all(names(x@name) %in% components))
  stopifnot(!anyDuplicated(names(x@name)))

  ret <- stats::na.omit(x@name[match(components, names(x@name))])
  SQL(paste0(dbQuoteIdentifier(conn, ret), collapse = "."))
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "Id"), dbQuoteIdentifier_MariaDBConnection_Id)
