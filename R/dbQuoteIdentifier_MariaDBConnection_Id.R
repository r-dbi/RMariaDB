#' @name mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_Id <- function(conn, x, ...) {
  stopifnot(all(names(x@name) %in% c("schema", "table")))
  stopifnot(!anyDuplicated(names(x@name)))

  ret <- ""
  if ("schema" %in% names(x@name)) {
    ret <- paste0(ret, dbQuoteIdentifier(conn, x@name[["schema"]]), ".")
  }
  if ("table" %in% names(x@name)) {
    ret <- paste0(ret, dbQuoteIdentifier(conn, x@name[["table"]]))
  }
  SQL(ret)
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "Id"), dbQuoteIdentifier_MariaDBConnection_Id)
