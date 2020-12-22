#' @include MariaDBConnection.R
NULL

#' Quote MariaDB strings and identifiers.
#'
#' In MariaDB, identifiers are enclosed in backticks, e.g. `` `x` ``.
#'
#' @keywords internal
#' @name mariadb-quoting
#' @examples
#' if (mariadbHasDefault()) {
#'   con <- dbConnect(RMariaDB::MariaDB())
#'   dbQuoteIdentifier(con, c("a b", "a`b"))
#'   dbQuoteString(con, c("a b", "a'b"))
#'   dbDisconnect(con)
#' }
NULL

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "character"),
  function(conn, x, ...) {
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
)

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "SQL"),
  function(conn, x, ...) {
    x
  }
)

#' @export
#' @rdname mariadb-quoting
setMethod("dbQuoteIdentifier", c("MariaDBConnection", "Id"), function(conn, x, ...) {
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
})

#' @export
#' @rdname mariadb-quoting
setMethod("dbUnquoteIdentifier", c("MariaDBConnection", "SQL"), function(conn, x, ...) {
  id_rx <- "(?:`((?:[^`]|``)+)`|([^`. ]+))"

  rx <- paste0(
    "^",
    "(?:|", id_rx, "[.])",
    "(?:|", id_rx, ")",
    "$"
  )

  bad <- grep(rx, x, invert = TRUE)
  if (length(bad) > 0) {
    stop("Can't unquote ", x[bad[[1]]], call. = FALSE)
  }
  schema <- gsub(rx, "\\1\\2", x)
  schema <- gsub("``", "`", schema)
  table <- gsub(rx, "\\3\\4", x)
  table <- gsub("``", "`", table)

  ret <- Map(schema, table, f = as_table)
  names(ret) <- names(x)
  ret
})

as_table <- function(schema, table) {
  args <- c(schema = schema, table = table)
  # Also omits NA args
  args <- args[!is.na(args) & args != ""]
  do.call(Id, as.list(args))
}

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteString", c("MariaDBConnection", "character"),
  function(conn, x, ...) {
    SQL(connection_quote_string(conn@ptr, enc2utf8(x)))
  }
)

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteString", c("MariaDBConnection", "SQL"),
  function(conn, x, ...) {
    x
  }
)

#' @rdname mariadb-quoting
#' @export
setMethod("dbQuoteLiteral", signature("MariaDBConnection"),
  function(conn, x, ...) {
    # Switchpatching to avoid ambiguous S4 dispatch, so that our method
    # is used only if no alternatives are available.

    if (inherits(x, "difftime")) return(cast_difftime(callNextMethod()))

    callNextMethod()
  }
)

cast_difftime <- function(x) {
  SQL(paste0("CAST(", x, " AS time)"))
}
