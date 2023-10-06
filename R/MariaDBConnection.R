#' Class MariaDBConnection.
#'
#' `"MariaDBConnection"` objects are usually created by [DBI::dbConnect()].
#' They represent a connection to a MariaDB or MySQL database.
#'
#' The `"MySQLConnection"` class is a subclass of `"MariaDBConnection"`.
#' Objects of that class are created by `dbConnect(MariaDB(mysql = TRUE), ...)` to indicate
#' that the server is a MySQL server.
#' The \pkg{RMariaDB} package supports both MariaDB and MySQL servers, but the SQL dialect
#' and other details vary.
#' The default is to assume a MariaDB server.
#'
#' The older \pkg{RMySQL} package also implements the `"MySQLConnection"` class.
#' If both packages are loaded, the class of the connection object is determined by the
#' package that was loaded first.
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

#' @export
#' @keywords internal
#' @rdname MariaDBConnection-class
setClass("MySQLConnection",
  contains = "MariaDBConnection"
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
