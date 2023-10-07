#' Class MariaDBDriver with constructor MariaDB.
#'
#' An MariaDB driver implementing the R database (DBI) API.
#' This class should always be initialized with the [MariaDB()] function.
#' It returns a singleton that allows you to connect to MariaDB.
#'
#' @export
#' @keywords internal
setClass("MariaDBDriver",
  contains = "DBIDriver",
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
