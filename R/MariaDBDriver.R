#' Class MariaDBDriver with constructor MariaDB.
#'
#' An MariaDB driver implementing the R database (DBI) API.
#' This class should always be initialized with the [MariaDB()] function.
#' It returns a singleton that allows you to connect to MariaDB.
#'
#' The `"MySQLDriver"` class is a subclass of `"MariaDBDriver"`.
#' It is created by `MariaDB(mysql = TRUE)` to indicate intent to connect to a MySQL server.
#' The \pkg{RMariaDB} package supports both MariaDB and MySQL servers, but the SQL dialect
#' and other details vary.
#' The default is to assume a MariaDB server.
#'
#' The older \pkg{RMySQL} package also implements the `"MySQLDriver"` class.
#' If both packages are loaded, the class of the connection object is determined by the
#' package that was loaded first.
#'
#' @export
#' @keywords internal
setClass("MariaDBDriver",
  contains = "DBIDriver",
)

#' @export
#' @keywords internal
#' @rdname MariaDBDriver-class
setClass("MySQLDriver",
  contains = "MariaDBDriver",
)

#' MariaDB Check for Compiled Versus Loaded Client Library Versions
#'
#' This function prints out the compiled and loaded client library versions.
#'
#' @return A named integer vector of length two, the first element
#'   representing the compiled library version and the second element
#'   representing the loaded client library version.
#' @export
#' @examples
#' mariadbClientLibraryVersions()
mariadbClientLibraryVersions <- function() {
  version()
}

# Set during installation time for the correct library
PACKAGE_VERSION <- utils::packageVersion(utils::packageName())
