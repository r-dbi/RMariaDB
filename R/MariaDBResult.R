#' Class MariaDBResult
#'
#' MariaDB's query results class.  This classes encapsulates the result of an SQL
#' statement (either \code{select} or not).
#'
#' @export
#' @keywords internal
setClass("MariaDBResult",
  contains = "DBIResult",
  slots = list(
    ptr = "externalptr",
    sql = "character"
  )
)

#' @rdname MariaDBResult-class
#' @export
setMethod("dbIsValid", "MariaDBResult", function(dbObj, ...) {
  result_active(dbObj@ptr)
})

