#' Class MariaDBResult
#'
#' MariaDB's query results class.  This classes encapsulates the result of an SQL
#' query or statement.
#'
#' @export
#' @keywords internal
setClass("MariaDBResult",
  contains = "DBIResult",
  slots = list(
    ptr = "externalptr",
    sql = "character",
    bigint = "character",
    conn = "MariaDBConnection"
  )
)
