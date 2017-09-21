#include "pch.h"

#include "RMariaDB_types.h"

// [[Rcpp::export]]
XPtr<MariaResult> result_create(XPtr<MariaConnectionPtr> con, std::string sql) {
  (*con)->check_connection();
  std::auto_ptr<MariaResult> res(new MariaResult(*con));
  res->send_query(sql);
  return XPtr<MariaResult>(res.release(), true);
}

// [[Rcpp::export]]
List result_column_info(XPtr<MariaResult> rs) {
  return rs->column_info();
}

// [[Rcpp::export]]
List result_fetch(XPtr<MariaResult> rs, int n) {
  return rs->fetch(n);
}

// [[Rcpp::export]]
void result_bind(XPtr<MariaResult> rs, List params) {
  return rs->bind(params);
}

// [[Rcpp::export]]
void result_bind_rows(XPtr<MariaResult> rs, List params) {
  return rs->bind_rows(params);
}

// [[Rcpp::export]]
void result_release(XPtr<MariaResult> rs) {
  rs.release();
}

// [[Rcpp::export]]
int result_rows_affected(XPtr<MariaResult> rs) {
  return rs->rows_affected();
}

// [[Rcpp::export]]
int result_rows_fetched(XPtr<MariaResult> rs) {
  return rs->rows_fetched();
}

// [[Rcpp::export]]
bool result_complete(XPtr<MariaResult> rs) {
  return rs->complete();
}

// [[Rcpp::export]]
bool result_active(XPtr<MariaResult> rs) {
  return rs.get() != NULL &&  rs->active();
}
