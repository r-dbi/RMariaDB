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
