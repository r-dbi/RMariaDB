# show()
#' @rdname MariaDBConnection-class
#' @usage NULL
show_MariaDBConnection <- function(object) {
  info <- dbGetInfo(object)
  cat("<MariaDBConnection>\n")
  if (dbIsValid(object)) {
    cat("  Host:    ", info$host, "\n", sep = "")
    cat("  Server:  ", info$serverVersion, "\n", sep = "")
    cat("  Client:  ", info$client, "\n", sep = "")
    # cat("  Proto:   ", info$protocolVersion, "\n", sep = "")
    # cat("  ThreadId:", info$threadId, "\n", sep = "")
    # cat("  User:    ", info$user, "\n", sep = "")
    # cat("  ConType: ", info$conType, "\n", sep = "")
    # cat("  Db:      ", info$dbname, "\n", sep = "")
  } else {
    cat("  DISCONNECTED\n")
  }
}

#' @rdname MariaDBConnection-class
#' @export
setMethod("show", "MariaDBConnection", show_MariaDBConnection)
