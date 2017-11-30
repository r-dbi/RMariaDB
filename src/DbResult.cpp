#include "pch.h"

#include "DbResult.h"
#include "MariaResultPrep.h"
#include "MariaResultSimple.h"

DbResult::DbResult(DbConnectionPtr maria_conn_) : maria_conn(maria_conn_) {
}

DbResult::~DbResult() {
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

bool DbResult::active() const {
  return maria_conn->is_current_result(this);
}

void DbResult::exec(const std::string& sql) {
  maria_conn->exec(sql);
}

void DbResult::autocommit() {
  maria_conn->autocommit();
}

DbResult* DbResult::create_and_send_query(DbConnectionPtr con, const std::string& sql, bool is_statement) {
  std::auto_ptr<DbResult> res(new MariaResultPrep(con, is_statement));
  try {
    res->send_query(sql);
  }
  catch (MariaResultPrep::UnsupportedPS e) {
    res.reset(NULL);
    // is_statement info might be worthwhile to pass to simple queries as well 
    res.reset(new MariaResultSimple(con));
    res->send_query(sql);
  }

  return res.release();
}
