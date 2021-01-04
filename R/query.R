#' @include MariaDBConnection.R
#' @include MariaDBResult.R
NULL

#' Execute a SQL statement on a database connection.
#'
#' To retrieve results a chunk at a time, use [dbSendQuery()],
#' [dbFetch()], then [dbClearResult()]. Alternatively, if you want all the
#' results (and they'll fit in memory) use [dbGetQuery()] which sends,
#' fetches and clears for you. For data manipulation queries (i.e. queries
#' that do not return data, such as \code{UPDATE}, \code{DELETE}, etc.),
#' [dbSendStatement()] serves as a counterpart to [dbSendQuery()], while
#' [dbExecute()] corresponds to [dbGetQuery()].
#'
#' @param conn an [MariaDBConnection-class] object.
#' @param res A  [MariaDBResult-class] object.
#' @inheritParams DBI::sqlRownamesToColumn
#' @param n Number of rows to retrieve. Use -1 to retrieve all rows.
#' @param params A list of query parameters to be substituted into
#'   a parameterised query.
#' @param statement a character vector of length one specifying the SQL
#'   statement that should be executed.  Only a single SQL statement should be
#'   provided.
#' @param ... Unused. Needed for compatibility with generic.
#' @export
#' @examples
#' if (mariadbHasDefault()) {
#' con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#' dbWriteTable(con, "arrests", datasets::USArrests, temporary = TRUE)
#'
#' # Run query to get results as dataframe
#' dbGetQuery(con, "SELECT * FROM arrests limit 3")
#'
#' # Send query to pull requests in batches
#' res <- dbSendQuery(con, "SELECT * FROM arrests")
#' data <- dbFetch(res, n = 2)
#' data
#' dbHasCompleted(res)
#'
#' dbClearResult(res)
#' dbDisconnect(con)
#' }
#' @rdname query
setMethod("dbFetch", "MariaDBResult",
  function(res, n = -1, ..., row.names = FALSE) {
    if (length(n) != 1) stopc("n must be scalar")
    if (n < -1) stopc("n must be nonnegative or -1")
    if (is.infinite(n)) n <- -1
    if (trunc(n) != n) stopc("n must be a whole number")
    ret <- result_fetch(res@ptr, n = n)
    ret <- convert_bigint(ret, res@bigint)
    ret <- fix_timezone(ret, res@conn)
    ret <- sqlColumnToRownames(ret, row.names)
    set_tidy_names(ret)
  }
)

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

#' @rdname query
#' @export
setMethod("dbSendQuery", c("MariaDBConnection", "character"),
  function(conn, statement, params = NULL, ...) {
    dbSend(conn, statement, params, is_statement = FALSE)
  }
)

#' @rdname query
#' @export
setMethod("dbSendStatement", signature("MariaDBConnection", "character"),
  function(conn, statement, params = NULL, ...) {
    dbSend(conn, statement, params, is_statement = TRUE)
  }
)

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


#' @rdname query
#' @export
setMethod("dbBind", "MariaDBResult", function(res, params, ...) {
  if (!is.null(names(params))) {
    stopc("Cannot use named parameters for anonymous placeholders")
  }

  params <- sql_data(as.list(params), res@conn, warn = TRUE)

  result_bind(res@ptr, params)
  invisible(res)
})

#' @rdname query
#' @export
setMethod("dbClearResult", "MariaDBResult", function(res, ...) {
  if (!dbIsValid(res)) {
    warningc("Expired, result set already closed")
    return(invisible(TRUE))
  }
  result_release(res@ptr)
  invisible(TRUE)
})

#' @rdname query
#' @export
setMethod("dbGetStatement", "MariaDBResult", function(res, ...) {
  if (!dbIsValid(res)) {
    stopc("Expired, result set already closed")
  }
  res@sql
})

#' Database interface meta-data.
#'
#' See documentation of generics for more details.
#'
#' @param res An object of class [MariaDBResult-class]
#' @param ... Ignored. Needed for compatibility with generic
#' @examples
#' if (mariadbHasDefault()) {
#' con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#' dbWriteTable(con, "t1", datasets::USArrests, temporary = TRUE)
#'
#' rs <- dbSendQuery(con, "SELECT * FROM t1 WHERE UrbanPop >= 80")
#' rs
#'
#' dbGetStatement(rs)
#' dbHasCompleted(rs)
#' dbColumnInfo(rs)
#'
#' dbFetch(rs)
#' rs
#'
#' dbClearResult(rs)
#' dbDisconnect(con)
#' }
#' @name result-meta
NULL

#' @export
#' @rdname result-meta
setMethod("dbColumnInfo", "MariaDBResult", function(res, ...) {
  df <- result_column_info(res@ptr)
  df$name <- tidy_names(df$name)
  df
})

#' @export
#' @rdname result-meta
setMethod("dbGetRowsAffected", "MariaDBResult", function(res, ...) {
  result_rows_affected(res@ptr)
})

#' @export
#' @rdname result-meta
setMethod("dbGetRowCount", "MariaDBResult", function(res, ...) {
  result_rows_fetched(res@ptr)
})

#' @export
#' @rdname result-meta
setMethod("dbHasCompleted", "MariaDBResult", function(res, ...) {
  result_has_completed(res@ptr)
})
