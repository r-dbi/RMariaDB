RMariaDB
======

NOTE: This package is a replacement for the old [RMySQL](https://cran.r-project.org/package=RMySQL) package.

> Database Interface and MariaDB Driver for R

[![Build Status](https://travis-ci.org/rstats-db/RMariaDB.svg)](https://travis-ci.org/rstats-db/RMariaDB)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/rstats-db/RMariaDB?branch=master&svg=true)](https://ci.appveyor.com/project/rstats-db/RMariaDB?branch=master)
[![Coverage Status](https://codecov.io/github/rstats-db/RMariaDB/coverage.svg)](https://codecov.io/github/rstats-db/RMariaDB)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/RMariaDB)](https://cran.r-project.org/package=RMariaDB)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/RMariaDB)](https://cran.r-project.org/package=RMariaDB)

RMariaDB is a database interface and MariaDB driver for R. This version is aimed at full compliance with the [DBI specification](https://cran.r-project.org/package=DBI/vignettes/spec.html).

## Hello World

```R
library(DBI)
# Connect to my-db as defined in ~/.my.cnf
con <- dbConnect(RMariaDB::MariaDB(), group = "my-db")

dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbListTables(con)

dbListFields(con, "mtcars")
dbReadTable(con, "mtcars")

# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)
dbClearResult(res)

# Or a chunk at a time
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
while(!dbHasCompleted(res)){
  chunk <- dbFetch(res, n = 5)
  print(nrow(chunk))
}
# Clear the result
dbClearResult(res)

# Disconnect from the database
dbDisconnect(con)
```

## Installation

Binary packages for __OS X__ or __Windows__ can be installed directly from CRAN:

```r
install.packages("RMariaDB")
```

The development version from github:

```R
# install.packages("devtools")
devtools::install_github("rstats-db/DBI")
devtools::install_github("rstats-db/RMariaDB")
```

Installation from source on Linux or OS X currently requires Oracle's [libmysqlclient](https://packages.debian.org/testing/libmysqlclient-dev) or the more modern [`MariaDB Connector/C`](https://downloads.mariadb.org/connector-c/). The latter works best in version 2.3.4/3.0.3 or later, with older versions character and blob columns do not work reliably.

### MySQL client library

On recent __Debian__ or __Ubuntu__ install [libmysqlclient-dev](https://packages.debian.org/testing/libmysqlclient-dev).

```
sudo apt-get install -y libmysqlclient-dev
```

On __Fedora__,  __CentOS__ or __RHEL__ we need [mysql-devel](https://apps.fedoraproject.org/packages/mysql-devel):

```
sudo yum install mysql-devel
```

Follow [instructions](https://dev.mysql.com/doc/mysql-yum-repo-quick-guide/en/) to enable the MySQL yum repository if the above command attempts to install MariaDB files.


On __OS X__ use [mysql-connector-c](https://github.com/Homebrew/homebrew-core/blob/master/Formula/mysql-connector-c.rb) from Homebrew:

```
brew install mysql-connector-c
```


### Connector/C

On recent __Debian__ or __Ubuntu__ install [libmariadb-client-lgpl-dev](https://packages.debian.org/testing/libmariadb-client-lgpl-dev). In Ubuntu 14.04 this was called [libmariadbclient-dev](http://packages.ubuntu.com/trusty/libmariadbclient-dev).

```
sudo apt-get install -y libmariadb-client-lgpl-dev
```

On __Fedora__,  __CentOS__ or __RHEL__ we need [mariadb-devel](https://apps.fedoraproject.org/packages/mariadb-devel):

```
sudo yum install mariadb-devel
````

On __OS X__ use [mariadb-connector-c](https://github.com/Homebrew/homebrew-core/blob/master/Formula/mariadb-connector-c.rb) from Homebrew:

```
brew install mariadb-connector-c
```


## MariaDB configuration file

Instead of specifying a username and password in calls to `dbConnect()`, it's better to set up a MariaDB configuration file that names the databases that you connect to most commonly. This file should live in `~/.my.cnf` and look like:

```
[database_name]
option1=value1
option2=value2
```

If you want to run the examples, you'll need to set the proper options in the `[rs-dbi]` group of any MariaDB option file, such as /etc/my.cnf or the .my.cnf file in your home directory. For a default single user install of MariaDB, the following code should work:

```
[rs-dbi]
database=test
user=root
password=
```

## Acknowledgements

Many thanks to Christoph M. Friedrich, John Heuer, Kurt Hornik, Torsten Hothorn, Saikat Debroy, Matthew Kelly, Brian D. Ripley, Mikhail Kondrin, Jake Luciani, Jens Nieschulze, Deepayan Sarkar, Louis Springer, Duncan Temple Lang, Luis Torgo, Arend P. van der Veen, Felix Weninger, J. T. Lindgren, Crespin Miller, and Michal Okonlewski, Seth Falcon and Paul Gilbert for comments, suggestions, bug reports, and patches to the original [RMySQL](https://cran.r-project.org/package=RMySQL) package, and to all contributors (of [code](https://github.com/rstats-db/RMariaDB/graphs/contributors) and discussions) to this package.
