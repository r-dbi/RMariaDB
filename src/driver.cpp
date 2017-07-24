#include "pch.h"

#include <mysql_version.h>

// [[Rcpp::export]]
void driver_init() {
  mysql_library_init(0, NULL, NULL);
}

// [[Rcpp::export]]
void driver_done() {
  mysql_library_end();
}

// [[Rcpp::export]]
IntegerVector version() {
  return
    IntegerVector::create(
      _[MYSQL_SERVER_VERSION] = MYSQL_VERSION_ID,
      _[mysql_get_client_info()] = mysql_get_client_version()
    );
}
