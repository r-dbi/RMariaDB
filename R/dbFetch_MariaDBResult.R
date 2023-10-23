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
#' @param conn A [MariaDBConnection-class] object.
#' @param res A [MariaDBResult-class] object.
#' @inheritParams DBI::sqlRownamesToColumn
#' @param n Number of rows to retrieve. Use -1 to retrieve all rows.
#' @param params A list of query parameters to be substituted into
#'   a parameterised query.
#' @param statement A character vector of length one specifying the SQL
#'   statement that should be executed.  Only a single SQL statement should be
#'   provided.
#' @param ... Unused. Needed for compatibility with generic.
#' @param immediate If TRUE, uses the `mysql_real_query()` API
#'   instead of `mysql_stmt_init()`.
#'   This allows passing multiple statements (with [CLIENT_MULTI_STATEMENTS])
#'   and turns off the ability to pass parameters.
#' @examples
#' if (mariadbHasDefault()) {
#'   con <- dbConnect(RMariaDB::MariaDB(), dbname = "test")
#'   dbWriteTable(con, "arrests", datasets::USArrests, temporary = TRUE)
#'
#'   # Run query to get results as dataframe
#'   dbGetQuery(con, "SELECT * FROM arrests limit 3")
#'
#'   # Send query to pull requests in batches
#'   res <- dbSendQuery(con, "SELECT * FROM arrests")
#'   data <- dbFetch(res, n = 2)
#'   data
#'   dbHasCompleted(res)
#'
#'   dbClearResult(res)
#'   dbDisconnect(con)
#' }
#' @rdname query
#' @usage NULL
dbFetch_MariaDBResult <- function(res, n = -1, ..., row.names = FALSE) {
  if (length(n) != 1) stopc("n must be scalar")
  if (n < -1) stopc("n must be nonnegative or -1")
  if (is.infinite(n)) n <- -1
  if (trunc(n) != n) stopc("n must be a whole number")
  ret <- result_fetch(res@ptr, n = n)
  ret <- convert_bigint(ret, res@bigint)
  ret <- fix_timezone(ret, res@conn)
  ret <- fix_blob(ret)
  ret <- sqlColumnToRownames(ret, row.names)
  set_tidy_names(ret)
}

#' @rdname query
#' @export
setMethod("dbFetch", "MariaDBResult", dbFetch_MariaDBResult)
