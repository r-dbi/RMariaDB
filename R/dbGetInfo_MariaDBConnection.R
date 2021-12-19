# dbSendQuery()
# dbSendStatement()
# dbDataType()
# dbQuoteString()
# dbQuoteIdentifier()
# dbWriteTable()
# dbReadTable()
# dbListTables()
# dbExistsTable()
# dbListFields()
# dbRemoveTable()
# dbGetInfo()
#' @rdname MariaDBConnection-class
#' @usage NULL
dbGetInfo_MariaDBConnection <- function(dbObj, what = "", ...) {
  connection_info(dbObj@ptr)
}

#' @rdname MariaDBConnection-class
#' @export
setMethod("dbGetInfo", "MariaDBConnection", dbGetInfo_MariaDBConnection)
