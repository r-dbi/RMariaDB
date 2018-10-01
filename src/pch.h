#include <Rcpp.h>
#include <mysql.h>

#include <plogr.h>

using namespace Rcpp;

#if MYSQL_VERSION_ID >= 80000 && MYSQL_VERSION_ID < 100000
#define my_bool bool
#endif
