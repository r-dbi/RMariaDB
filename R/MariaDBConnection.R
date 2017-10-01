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
    db = "character"
  )
)

#' @export
#' @rdname MariaDBConnection-class
setMethod("dbDisconnect", "MariaDBConnection", function(conn, ...) {
  connection_release(conn@ptr)
  invisible(TRUE)
})

#' @export
#' @rdname MariaDBConnection-class
setMethod("dbGetInfo", "MariaDBConnection", function(dbObj, what="", ...) {
  connection_info(dbObj@ptr)
})

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

#' @export
#' @rdname MariaDBConnection-class
setMethod("dbIsValid", "MariaDBConnection", function(dbObj, ...) {
  connection_valid(dbObj@ptr)
})
