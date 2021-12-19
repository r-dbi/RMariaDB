#' @include MariaDBConnection.R
#' @include MariaDBResult.R
NULL

convert_bigint <- function(df, bigint) {
  if (bigint == "integer64") return(df)
  is_int64 <- which(vlapply(df, inherits, "integer64"))
  if (length(is_int64) == 0) return(df)

  as_bigint <- switch(bigint,
    integer = as.integer,
    numeric = as.numeric,
    character = as.character
  )

  df[is_int64] <- suppressWarnings(lapply(df[is_int64], as_bigint))
  df
}

fix_timezone <- function(ret, conn) {
  is_datetime <- which(vapply(ret, inherits, "POSIXt", FUN.VALUE = logical(1)))
  if (length(is_datetime) > 0) {
    ret[is_datetime] <- lapply(ret[is_datetime], function(x) {
      x <- lubridate::with_tz(x, "UTC")
      x <- lubridate::force_tz(x, conn@timezone)
      lubridate::with_tz(x, conn@timezone_out)
    })
  }

  ret
}

fix_blob <- function(ret) {
  is_blob <- which(vapply(ret, is.list, FUN.VALUE = logical(1)))
  if (length(is_blob) > 0) {
    ret[is_blob] <- lapply(ret[is_blob], blob::as_blob)
  }

  ret
}

dbSend <- function(conn, statement, params = NULL, is_statement) {
  statement <- enc2utf8(statement)

  rs <- new("MariaDBResult",
    sql = statement,
    ptr = result_create(conn@ptr, statement, is_statement),
    bigint = conn@bigint,
    conn = conn
  )

  on.exit(dbClearResult(rs))

  if (!is.null(params)) {
    dbBind(rs, params)
  }

  on.exit(NULL)
  rs
}

#' Database interface meta-data.
#'
#' See documentation of generics for more details.
#'
#' @param res An object of class [MariaDBResult-class]
#' @param ... Ignored. Needed for compatibility with generic
#' @examples
#' if (mariadbHasDefault()) {
#'   con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#'   dbWriteTable(con, "t1", datasets::USArrests, temporary = TRUE)
#'
#'   rs <- dbSendQuery(con, "SELECT * FROM t1 WHERE UrbanPop >= 80")
#'   rs
#'
#'   dbGetStatement(rs)
#'   dbHasCompleted(rs)
#'   dbColumnInfo(rs)
#'
#'   dbFetch(rs)
#'   rs
#'
#'   dbClearResult(rs)
#'   dbDisconnect(con)
#' }
#' @name result-meta
NULL
