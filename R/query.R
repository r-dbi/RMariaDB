#' @include MariaDBConnection.R
#' @include MariaDBResult.R
NULL

#' Execute a SQL statement on a database connection.
#'
#' To retrieve results a chunk at a time, use [dbSendQuery()],
#' [dbFetch()], then [dbClearResult()]. Alternatively, if you want all the
#' results (and they'll fit in memory) use [dbGetQuery()] which sends,
#' fetches and clears for you.
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
#' dbWriteTable(con, "arrests", datasets::USArrests, overwrite = TRUE)
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
#' dbRemoveTable(con, "arrests")
#' dbDisconnect(con)
#' }
#' @rdname query
setMethod("dbFetch", "MariaDBResult",
  function(res, n = -1, ..., row.names = FALSE) {
    if (length(n) != 1) stopc("n must be scalar")
    if (n < -1) stopc("n must be nonnegative or -1")
    if (is.infinite(n)) n <- -1
    if (trunc(n) != n) stopc("n must be a whole number")
    sqlColumnToRownames(result_fetch(res@ptr, n), row.names)
  }
)

#' @rdname query
#' @export
setMethod("dbSendQuery", c("MariaDBConnection", "character"),
  function(conn, statement, params = NULL, ...) {
    statement <- enc2utf8(statement)

    rs <- new("MariaDBResult",
      sql = statement,
      ptr = result_create(conn@ptr, statement)
    )

    if (!is.null(params)) {
      dbBind(rs, params)
    }

    rs
  }
)

#' @rdname query
#' @export
setMethod("dbBind", "MariaDBResult", function(res, params, ...) {
  if (!is.null(names(params))) {
    stopc("Cannot use named parameters for anonymous placeholders")
  }

  params <- sql_data(params, warn = TRUE)

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
#' dbWriteTable(con, "t1", datasets::USArrests, overwrite = TRUE)
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
#' dbRemoveTable(con, "t1")
#' dbDisconnect(con)
#' }
#' @name result-meta
NULL

#' @export
#' @rdname result-meta
setMethod("dbColumnInfo", "MariaDBResult", function(res, ...) {
  result_column_info(res@ptr)
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
  result_complete(res@ptr)
})
