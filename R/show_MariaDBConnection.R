# show()
#' @rdname MariaDBConnection-class
#' @usage NULL
show_MariaDBConnection <- function(object) {
  info <- dbGetInfo(object)
  cat("<", class(object), ">\n", sep = "")
  if (dbIsValid(object)) {
    cat("  Hostname:       ", info$host, "\n", sep = "")
    cat("  Username:       ", info$user, "\n", sep = "")
    cat("  Database:       ", info$dbname, "\n", sep = "")
    cat("  Server Port:    ", info$port, "\n", sep = "")
    cat("  Connection:     ", info$con.type, "\n", sep = "")
    cat("  Protocol:       ", info$protocol.version, "\n", sep = "")
    if (!is.null(info$ssl.cipher)) {
      cat("  SSL Cipher:     ", info$ssl.cipher, "\n", sep = "")
    }
    cat("  Thread Id:      ", info$thread.id, "\n", sep = "")
    cat("  Client Version: ", info$client.version, "\n", sep = "")
    cat("  Client Flags:   ", format(as.hexmode(info$client.flag), width=8, upper.case=T), "\n", sep = "")
    cat("  Server Version: ", info$db.version, "\n", sep = "")
    cat("  Capabilities:   ", format(as.hexmode(info$server.capabilities), width=8, upper.case=T), "\n", sep = "")
    cat("  SQL Status:     ", format(as.hexmode(info$status), width=8, upper.case=T), "\n", sep = "")
  } else {
    cat("  DISCONNECTED\n")
  }
}

#' @rdname MariaDBConnection-class
#' @export
setMethod("show", "MariaDBConnection", show_MariaDBConnection)
