#include "pch.h"

#include "RMariaDB_types.h"

// [[Rcpp::export]]
XPtr<DbResult> result_create(XPtr<DbConnectionPtr> con, std::string sql, bool is_statement = false) {
  (*con)->check_connection();
  return XPtr<DbResult>(DbResult::create_and_send_query(*con, sql, is_statement), true);
}

// [[Rcpp::export]]
List result_column_info(XPtr<DbResult> rs) {
  return rs->column_info();
}

// [[Rcpp::export]]
List result_fetch(XPtr<DbResult> rs, int n) {
  return rs->fetch(n);
}

// [[Rcpp::export]]
void result_bind(XPtr<DbResult> rs, List params) {
  return rs->bind(params);
}

// [[Rcpp::export]]
void result_release(XPtr<DbResult> rs) {
  rs.release();
}

// [[Rcpp::export]]
int result_rows_affected(XPtr<DbResult> rs) {
  return rs->rows_affected();
}

// [[Rcpp::export]]
int result_rows_fetched(XPtr<DbResult> rs) {
  return rs->rows_fetched();
}

// [[Rcpp::export]]
bool result_complete(XPtr<DbResult> rs) {
  return rs->complete();
}

// [[Rcpp::export]]
bool result_active(XPtr<DbResult> rs) {
  return rs.get() != NULL &&  rs->active();
}

namespace Rcpp {

template<>
DbResult* as(SEXP x) {
  DbResult* result = (DbResult*)(R_ExternalPtrAddr(x));
  if (!result)
    stop("Invalid result set");
  return result;
}

}
