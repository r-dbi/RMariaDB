#' Determine the SQL Data Type of an S object
#'
#' This method is a straight-forward implementation of the corresponding
#' generic function.
#'
#' @param dbObj A [MariaDBDriver-class] or [MariaDBConnection-class] object.
#' @param obj R/S-Plus object whose SQL type we want to determine.
#' @param \dots any other parameters that individual methods may need.
#' @name dbDataType
#' @examples
#' dbDataType(RMariaDB::MariaDB(), "a")
#' dbDataType(RMariaDB::MariaDB(), 1:3)
#' dbDataType(RMariaDB::MariaDB(), 2.5)
#' @usage NULL
dbDataType_MariaDBConnection <- function(dbObj, obj, ...) {
  dbDataType(MariaDB(), obj, ...)
}

#' @rdname dbDataType
#' @export
setMethod("dbDataType", "MariaDBConnection", dbDataType_MariaDBConnection)
