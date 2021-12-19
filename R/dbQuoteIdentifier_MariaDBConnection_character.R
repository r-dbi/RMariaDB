#' @rdname mariadb-quoting
#' @usage NULL
dbQuoteIdentifier_MariaDBConnection_character <- function(conn, x, ...) {
  if (any(is.na(x))) {
    stop("Cannot pass NA to dbQuoteIdentifier()", call. = FALSE)
  }
  x <- gsub("`", "``", x, fixed = TRUE)
  if (length(x) == 0L) {
    SQL(character(), names = names(x))
  } else {
    # Not calling encodeString() here to keep things simple
    SQL(paste("`", x, "`", sep = ""), names = names(x))
  }
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "character"), dbQuoteIdentifier_MariaDBConnection_character)
