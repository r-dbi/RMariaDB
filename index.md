# RMariaDB

RMariaDB is a database interface and MariaDB driver for R. This version
is aimed at full compliance with the [DBI
specification](https://cran.r-project.org/package=DBI/vignettes/spec.html),
as a replacement for the old
[RMySQL](https://cran.r-project.org/package=RMySQL) package.

## Hello World

``` r
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

Binary packages for **OS X** or **Windows** can be installed directly
from CRAN:

``` r
install.packages("RMariaDB")
```

The development version from github:

``` r
# install.packages("devtools")
devtools::install_github("r-dbi/DBI")
devtools::install_github("r-dbi/RMariaDB")
```

Discussions associated with DBI and related database packages take place
on [R-SIG-DB](https://stat.ethz.ch/mailman/listinfo/r-sig-db). The
website [Databases using R](https://db.rstudio.com/) describes the tools
and best practices in this ecosystem.

Installation from source on Linux or OS X currently requires
[`MariaDB Connector/C`](https://downloads.mariadb.org/connector-c/),
preferably in version 2.3.4/3.0.3 or later. With older versions,
character and blob columns do not work reliably. Alternatively, Oracle’s
[libmysqlclient](https://packages.debian.org/buster/default-libmysqlclient-dev)
can be used.

### Connector/C

On recent **Debian** or **Ubuntu** install
[libmariadb-dev](https://packages.debian.org/testing/libmariadb-dev).

    sudo apt-get install -y libmariadb-dev

On **Fedora**, **CentOS** or **RHEL** we need
[mariadb-devel](https://src.fedoraproject.org/rpms/mariadb):

    sudo yum install mariadb-devel

On **OS X** use
[mariadb-connector-c](https://github.com/Homebrew/homebrew-core/blob/master/Formula/m/mariadb-connector-c.rb)
from Homebrew:

    brew install mariadb-connector-c

### MySQL client library

On recent **Debian** or **Ubuntu** install
[libmysqlclient-dev](https://packages.debian.org/buster/default-libmysqlclient-dev).

    sudo apt-get install -y libmysqlclient-dev

On **Fedora**, **CentOS** or **RHEL** we need mysql-devel, see
<https://apps.fedoraproject.org/packages/mysql-devel>:

    sudo yum install mysql-devel

Follow
[instructions](https://dev.mysql.com/doc/mysql-yum-repo-quick-guide/en/)
to enable the MySQL yum repository if the above command attempts to
install MariaDB files.

On **OS X** use
[mysql-connector-c](https://github.com/Homebrew/homebrew-core/blob/master/Formula/m/mysql-connector-c++.rb)
from Homebrew:

    brew install mysql-connector-c++

## MariaDB configuration file

Instead of specifying a username and password in calls to
[`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html), it’s
better to set up a MariaDB configuration file that names the databases
that you connect to most commonly. This file should live in `~/.my.cnf`
and look like:

    [database_name]
    option1=value1
    option2=value2

If you want to run the examples, you’ll need to set the proper options
in the `[rs-dbi]` group of any MariaDB option file, such as /etc/my.cnf
or the .my.cnf file in your home directory. For a default single user
install of MariaDB, the following code should work:

    [rs-dbi]
    database="test"
    user="root"
    password=""

## Acknowledgements

Many thanks to Christoph M. Friedrich, John Heuer, Kurt Hornik, Torsten
Hothorn, Saikat Debroy, Matthew Kelly, Brian D. Ripley, Mikhail Kondrin,
Jake Luciani, Jens Nieschulze, Deepayan Sarkar, Louis Springer, Duncan
Temple Lang, Luis Torgo, Arend P. van der Veen, Felix Weninger, J. T.
Lindgren, Crespin Miller, and Michal Okonlewski, Seth Falcon and Paul
Gilbert for comments, suggestions, bug reports, and patches to the
original [RMySQL](https://cran.r-project.org/package=RMySQL) package,
and to all contributors (of
[code](https://github.com/r-dbi/RMariaDB/graphs/contributors) and
discussions) to this package.

------------------------------------------------------------------------

Please note that the ‘RMariaDB’ project is released with a [Contributor
Code of Conduct](https://rmariadb.r-dbi.org/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
