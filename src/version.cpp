#include "pch.h"

#include <mysql_version.h>

// [[Rcpp::export]]
IntegerVector version() {
  return
    IntegerVector::create(
      _[MYSQL_SERVER_VERSION] = MYSQL_VERSION_ID,
      _[mysql_get_client_info()] = mysql_get_client_version()
    );
}
