#include "pch.h"
#include "DbResult.h"
#include "MariaResultPrep.h"
#include "MariaResultSimple.h"



// Construction ////////////////////////////////////////////////////////////////

DbResult::DbResult(const DbConnectionPtr& pConn) :
  pConn_(pConn)
{
  pConn_->set_current_result(this);
}

DbResult::~DbResult() {
  try {
    pConn_->set_current_result(NULL);
  } catch (...) {};
}

DbResult* DbResult::create_and_send_query(const DbConnectionPtr& con, const std::string& sql, bool is_statement) {
  std::auto_ptr<DbResult> res(new DbResult(con));
  res->send_query(sql, is_statement);

  return res.release();
}

void DbResult::close() {
  // Called from destructor
  if (impl) impl->close();
}

// Publics /////////////////////////////////////////////////////////////////////

bool DbResult::complete() const {
  return (impl == NULL) || impl->complete();
}

bool DbResult::is_active() const {
  return pConn_->is_current_result(this);
}

int DbResult::n_rows_fetched() {
  return impl->n_rows_fetched();
}

int DbResult::n_rows_affected() {
  return impl->n_rows_affected();
}

void DbResult::bind(const List& params) {
  validate_params(params);
  impl->bind(params);
}

List DbResult::fetch(const int n_max) {
  if (!is_active())
    stop("Inactive result set");

  return impl->fetch(n_max);
}

List DbResult::get_column_info() {
  List out = impl->get_column_info();

  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -Rf_length(out[0]));
  out.attr("class") = "data.frame";

  return out;
}

DbConnection* DbResult::get_db_conn() const {
  return pConn_.get();
}

MYSQL* DbResult::get_conn() const {
  return pConn_->get_conn();
}

// Privates ///////////////////////////////////////////////////////////////////

void DbResult::validate_params(const List& params) const {
  if (params.size() != 0) {
    SEXP first_col = params[0];
    int n = Rf_length(first_col);

    for (int j = 1; j < params.size(); ++j) {
      SEXP col = params[j];
      if (Rf_length(col) != n)
        stop("Parameter %i does not have length %d.", j + 1, n);
    }
  }
}

void DbResult::send_query(const std::string& sql, bool is_statement) {
  boost::scoped_ptr<MariaResultImpl> res(new MariaResultPrep(this, is_statement));
  try {
    res->send_query(sql);
  }
  catch (MariaResultPrep::UnsupportedPS e) {
    res.reset(NULL);
    // is_statement info might be worthwhile to pass to simple queries as well
    res.reset(new MariaResultSimple(this));
    res->send_query(sql);
  }

  res.swap(impl);
}
