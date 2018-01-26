#include "pch.h"

#include "DbResult.h"
#include "MariaResultPrep.h"
#include "MariaResultSimple.h"

DbResult::DbResult(DbConnectionPtr maria_conn_) :
  maria_conn(maria_conn_) {
  set_current_result();
}

DbResult::~DbResult() {
  try {
    clear_current_result();
  } catch (...) {};
}

DbResult* DbResult::create_and_send_query(DbConnectionPtr con, const std::string& sql, bool is_statement) {
  std::auto_ptr<DbResult> res(new DbResult(con));
  res->send_query(sql, is_statement);

  return res.release();
}

void DbResult::close() {
  // Called from destructor
  if (impl) impl->close();
}

bool DbResult::complete() {
  return impl->complete();
}

void DbResult::bind(const List& params) {
  impl->bind(params);
}

List DbResult::get_column_info() {
  return impl->get_column_info();
}

List DbResult::fetch(int n_max) {
  if (!is_active())
    stop("Inactive result set");
  return impl->fetch(n_max);
}

int DbResult::n_rows_affected() {
  return impl->n_rows_affected();
}

int DbResult::n_rows_fetched() {
  return impl->n_rows_fetched();
}

DbConnection* DbResult::get_db_conn() const {
  return maria_conn.get();
}

void DbResult::set_current_result() {
  maria_conn->set_current_result(this);
}

void DbResult::clear_current_result() {
  maria_conn->set_current_result(NULL);
}

MYSQL* DbResult::get_conn() const {
  return maria_conn->get_conn();
}

bool DbResult::is_active() const {
  return maria_conn->is_current_result(this);
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
