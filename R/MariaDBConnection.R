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
    load_data_local_infile = "logical",
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
