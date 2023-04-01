#' @name mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_Id <- function(conn, x, ...) {
  stopifnot(all(names(x@name) %in% c("catalog", "schema", "table")))
  stopifnot(!anyDuplicated(names(x@name)))

  ret <- ""
  if ("catalog" %in% names(x@name) && any(x@name[["catalog"]] != "def")) {
    stop('If a "catalog" component is supplied in `Id()`, it must be equal to "def" everywhere.', call. = FALSE)
  }
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
