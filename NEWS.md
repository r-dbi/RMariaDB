# RMariaDB 1.0 (2017-10-01)

Initial release, compliant to the DBI specification.

- Test almost all test cases of the DBI specification.
- Fully support parametrized queries (#22, #27, #39).
- Queries not supported by the prepared statement protocol still can be run via `dbExecute()` or `dbSendStatement()`, the function `mariadbExecQuery()` has been removed (#28).
- Spec-compliant transactions (#38, #49).
- 64-bit integers are now supported through the `bit64` package. Unfortunately, this also means that numeric literals (as in `SELECT 1`) are returned as 64-bit integers (#12).
- Correct handling of DATETIME and TIME columns (#52, @noahwilliamsson). Support timestamp values with sub-second precision on output, and with year beyond 2038 (#56).
- The connection now uses the "utf8mb4" charset by default (#7).
- New default `row.names = FALSE`.
- New SSL-related arguments to `dbConnect()`: `ssl.key`, `ssl.cert`, `ssl.ca`, `ssl.capath`, `ssl.cipher` (#131, #148, @adamchainz).
- CI for Linux, Windows, and OS X (#25).
- Support for Connector/C from both MariaDB and MySQL.


# RMariaDB 0.11-1 (2016-03-24)

 *  RMariaDB fully supports DATE and DATETIME columns. On output, DATE columns
    will be converted to vectors of `Date`s and DATETIME will be converted
    to `POSIXct`. To faciliate correct computation of time zone, RMariaDB
    always sets the session timezone to UTC.

 *  RMariaDB has been rewritten (essentially from scratch) in C++ with
    Rcpp. This has considerably reduced the amount of code, and allow us to
    take advantage of the more sophisticated memory management tools available in
    Rcpp. This rewrite should yield some minor performance improvements, but 
    most importantly protect against memory leaks and crashes. It also provides
    a better base for future development.

 *  Support for prepared queries: create prepared query with `dbSendQuery()` 
    and bind values with `dbBind()`. `dbSendQuery()` and `dbGetQuery()` also 
    support inline parameterised queries, like 
    `dbGetQuery(mariadbDefault(), "SELECT * FROM mtcars WHERE cyl = :cyl", 
    params = list(cyl = 4))`. This has no performance benefits but protects you 
    from SQL injection attacks.

 * `dbListFields()` has been removed. Please use `dbColumnInfo()` instead.

 * `dbGetInfo()` has been removed. Please use the individual metadata 
    functions.

 *  Information formerly contain in `summary()` methods has now been integrated
    into `show()` methods.

 *  `make.db.names()` has been deprecated. Use `dbQuoteIdentifier()` instead.
 
 *  `isIdCurrent()` has been deprecated. Use `dbIsValid()` instead.

 *  `dbApply()`, `dbMoreResults()` and `dbNextResults()` have been removed.
    These were always flagged as experimental, and now the experiment is over.

 *  `dbEscapeStrings()` has been deprecated. Please use `dbQuoteStrings()`
    instead.

 *  dbObjectId compatibility shim removed

 *  Add SSL support on Windows.

 *  Fix repetition of strings in subsequent rows (@peternowee, #125).

 *  Always set connection character set to utf-8

 *  Backport build system improvements from stable branch

 *  Reenable Travis-CI, switch to R Travis, collect coverage
