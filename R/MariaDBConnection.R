#' Class MariaDBConnection.
#'
#' `"MariaDBConnection"` objects are usually created by [DBI::dbConnect()].
#' They represent a connection to a MariaDB or MySQL database.
#'
#' The `"MySQLConnection"` class is a subclass of `"MariaDBConnection"`.
#' Objects of that class are created by `dbConnect(MariaDB(), ..., mysql = TRUE)`
#' to indicate that the server is a MySQL server.
#' The \pkg{RMariaDB} package supports both MariaDB and MySQL servers, but the SQL dialect
#' and other details vary.
#' The default is to detect the server type based on the version number.
#'
#' The older \pkg{RMySQL} package also implements the `"MySQLConnection"` class.
#' The S4 system is able to distinguish between \pkg{RMariaDB} and \pkg{RMySQL} objects
#' even if both packages are loaded.
#'
#' @keywords internal
MariaDBConnection <- setClass("MariaDBConnection",
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

#' @exportClass MariaDBConnection
NULL

#' @keywords internal
#' @name MariaDBConnection-class
#' @aliases MySQLConnection-class
MySQLConnection <- setClass("MySQLConnection",
  contains = "MariaDBConnection"
)

#' @exportClass MySQLConnection
NULL

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
