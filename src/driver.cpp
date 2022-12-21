#include "pch.h"

#if defined(MYSQL_SERVER_VERSION)
#define SERVER_VERSION MYSQL_SERVER_VERSION
#elif defined(MARIADB_CLIENT_VERSION_STR)
#define SERVER_VERSION MARIADB_CLIENT_VERSION_STR
#else
#define SERVER_VERSION "<unknown server version>"
#endif

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
  return IntegerVector::create(
      _[SERVER_VERSION] = MYSQL_VERSION_ID,
      _[mysql_get_client_info()] = mysql_get_client_version());
}

// [[Rcpp::export]]
void init_logging(const std::string& log_level) {
  plog::init_r(log_level);
}
