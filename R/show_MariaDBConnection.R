# show()
#' @rdname MariaDBConnection-class
#' @usage NULL
show_MariaDBConnection <- function(object) {
  info <- dbGetInfo(object)
  cat("<", class(object), ">\n", sep = "")
  if (dbIsValid(object)) {
    conInfo <- paste0(info$user, "@", info$host)
    if (info$port != 3306) {
      conInfo <- paste0(conInfo, ":", info$port)
    }
    conInfo <- paste0(conInfo, "<", info$dbname, ">[", info$thread.id, "]")
    conParts <- unlist(strsplit(info$con.type, split = " ", fixed = T))
    conInfo <- paste(conInfo, paste(conParts[-1], collapse = " "))
    if (!is.null(info$ssl.cipher)) {
      conInfo <- paste(conInfo, "over SSL")
    }
    cat("  Connection: ", conInfo, "\n", sep = "")
  } else {
    cat("  DISCONNECTED\n")
  }
}

#' @rdname MariaDBConnection-class
#' @export
setMethod("show", "MariaDBConnection", show_MariaDBConnection)
