## RMariaDB 0.11-9 (2017-10-01)

- Test almost all test cases of the DBI specification.
- Queries not supported by the prepared statement protocol can now be run via `dbExecute()` or `dbSendStatement()`, the function `mariadbExecQuery()` has been removed (#28).
- Avoid storing all results on the client due to instability with large datasets (#60, #61).


## RMariaDB 0.11-8 (2017-09-24)

- CI for Windows and OS X (#25).
- The entire result set is now buffered on the client, this is required when linking against MariaDB's Connector/C (#53).
- Fix segfault that occurs when passing wrong connection parameters.
- Avoid including `mysql_version.h` because it's missing on Fedora.
- Add workaround against undefined macros in Connector/C.


## RMariaDB 0.11-7 (2017-09-24)

- Improve documentation for location of option files, with reference (#18).
- Fully support parametrized queries (#22, #27, #39).
- Use snake_case in C++ code.
- Make transactions compliant to the spec (#38, #49).
- 64-bit integers are now supported through the `bit64` package. Unfortunately, this also means that numeric literals (as in `SELECT 1`) are returned as 64-bit integers (#12).
- Support timestamp values with sub-second precision on output.
- The connection now uses the "utf8mb4" charset by default (#7).
- The `port` and `client.flag` arguments to `dbConnect()` are coerced to integer (#4).
- Date values with the year beyond 2038 are supported (#56).
- Improve DBI compliance (#1, #5, #10, #15, #17, #40).
- Correct handling of DATETIME and TIME columns (#52, @noahwilliamsson).


## RMariaDB 0.11-6 (2017-08-07)

- Move implementations to `.cpp` files.
- Code compiles without pedantic, extra, and conversion warnings (minus `mysql.h`).
- Rcpp handles registration of native routines.
- Formatting code with astyle.
- Pass or skip all DBItest tests.
- Fix CI tests on Linux and Windows, disable tests on OS X.
- New default `row.names = FALSE`.


## RMariaDB 0.11-5 (2016-12-29)

- Add package-level documentation (#159, @Ironholds).
- The `host` and `db` slots of the `MariaDBConnection` object now contain actual host and database names, even if they were retrieved from a configuration file (#127, @peternowee).
- Fix typos in the documentation of `dbConnect()` (#175, @mcol).


## RMariaDB 0.11-4 (2016-12-29)

- Adapt to `DBItest` changes.
- Fix compiler warnings.
- Improve compatibility with different versions of `libmysql`.


# RMariaDB 0.11-3 (2016-06-08)

- Fix failing compilation on Linux if a  function is declared elsewhere.
- More robust check for numeric `NA` values.
- New SSL-related arguments to `dbConnect()`: `ssl.key`, `ssl.cert`, `ssl.ca`, `ssl.capath`, `ssl.cipher` (#131, #148, @adamchainz).
- Add `TAGS` file to .gitignore (@sambrightman, #78).
- Can build with MariaDB libraries on Ubuntu (#145).
- Use new `sqlRownamesToColumn()` and `sqlColumnToRownames()` (rstats-db/DBI#91).
- Use `const&` for `Rcpp::Nullable` (@peternowee, #129).
- Use container-based builds on Travis (#143).


# RMariaDB 0.11-2 (2016-03-29)

- Use the `DBItest` package for testing (#100).


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


# Version 0.10.1 and older: See RMySQL
