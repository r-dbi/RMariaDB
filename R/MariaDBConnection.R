#' Class MariaDBConnection.
#'
#' `MariaDBConnection` objects are usually created by
#' [DBI::dbConnect()]
#'
#' @export
#' @keywords internal
setClass("MariaDBConnection",
  contains = "DBIConnection",
  slots = list(
    ptr = "externalptr",
    host = "character",
    db = "character",
    bigint = "character",
    timezone = "character",
    timezone_out = "character"
  )
)

# format()
#' @export
#' @rdname MariaDBConnection-class
format.MariaDBConnection <- function(x, ...) {
  if (dbIsValid(x)) {
    info <- dbGetInfo(x)
    details <- paste0(info$dbname, "@", info$host)
  } else {
    details <- "DISCONNECTED"
  }

  paste0("<MariaDBConnection> ", details)
}

# show()
#' @export
#' @rdname MariaDBConnection-class
setMethod("show", "MariaDBConnection", function(object) {
  info <- dbGetInfo(object)
  cat("<MariaDBConnection>\n")
  if (dbIsValid(object)) {
    cat("  Host:    ", info$host, "\n", sep = "")
    cat("  Server:  ", info$serverVersion, "\n", sep = "")
    cat("  Client:  ", info$client, "\n", sep = "")
    #cat("  Proto:   ", info$protocolVersion, "\n", sep = "")
    #cat("  ThreadId:", info$threadId, "\n", sep = "")
    #cat("  User:    ", info$user, "\n", sep = "")
    #cat("  ConType: ", info$conType, "\n", sep = "")
    #cat("  Db:      ", info$dbname, "\n", sep = "")
  } else {
    cat("  DISCONNECTED\n")
  }
})

# dbIsValid()
#' @export
#' @rdname MariaDBConnection-class
setMethod("dbIsValid", "MariaDBConnection", function(dbObj, ...) {
  connection_valid(dbObj@ptr)
})

# dbDisconnect()
#' @export
#' @rdname MariaDBConnection-class
setMethod("dbDisconnect", "MariaDBConnection", function(conn, ...) {
  connection_release(conn@ptr)
  invisible(TRUE)
})

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
#' @export
#' @rdname MariaDBConnection-class
setMethod("dbGetInfo", "MariaDBConnection", function(dbObj, what="", ...) {
  connection_info(dbObj@ptr)
})

# dbBegin()

# dbCommit()

# dbRollback()

# other
