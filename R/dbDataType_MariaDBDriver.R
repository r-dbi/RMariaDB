#' @rdname dbDataType
#' @usage NULL
dbDataType_MariaDBDriver <- function(dbObj, obj, ...) {
  if (is.factor(obj)) return(get_char_type(levels(obj)))
  if (inherits(obj, "POSIXct")) return("DATETIME(6)")
  if (inherits(obj, "Date")) return("DATE")
  if (inherits(obj, "difftime")) return("TIME(6)")
  if (inherits(obj, "integer64")) return("BIGINT")
  if (is.data.frame(obj)) return(callNextMethod(dbObj, obj))

  switch(typeof(obj),
    logical = "TINYINT", # works better than BIT(1), https://stackoverflow.com/q/289727/946850
    integer = "INTEGER",
    double = "DOUBLE",
    character = get_char_type(obj),
    list = "BLOB",
    stop("Unsupported type", call. = FALSE)
  )
}

#' @rdname dbDataType
#' @export
setMethod("dbDataType", "MariaDBDriver", dbDataType_MariaDBDriver)
