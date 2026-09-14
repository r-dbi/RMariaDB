#include "pch.h"
#include "RMariaDB_types.h"
#include "MariaResult.h"

[[cpp11::register]]
cpp11::external_pointer<DbResult> result_create(
  cpp11::external_pointer<DbConnectionPtr> con,
  std::string sql,
  bool is_statement = false,
  bool immediate = false
) {
  (*con)->check_connection();
  DbResult* res =
    MariaResult::create_and_send_query(*con, sql, is_statement, immediate);
  return cpp11::external_pointer<DbResult>(res, true);
}

// TODO: figure out what is release in RSQLite
[[cpp11::register]]
void result_release(cpp11::external_pointer<DbResult> res) {
  res.reset();
}

[[cpp11::register]]
bool result_valid(cpp11::external_pointer<DbResult> res_) {
  DbResult* res = res_.get();
  return res != NULL && res->is_active();
}

[[cpp11::register]]
cpp11::list result_fetch(DbResult* res, const int n) {
  return res->fetch(n);
}

[[cpp11::register]]
void result_bind(DbResult* res, cpp11::list params) {
  res->bind(params);
}

[[cpp11::register]]
bool result_has_completed(DbResult* res) {
  return res->complete();
}

[[cpp11::register]]
int result_rows_fetched(DbResult* res) {
  return res->n_rows_fetched();
}

[[cpp11::register]]
int result_rows_affected(DbResult* res) {
  return res->n_rows_affected();
}

[[cpp11::register]]
cpp11::list result_column_info(DbResult* res) {
  return res->get_column_info();
}

[[cpp11::register]]
cpp11::logicals result_is_unsigned_int(DbResult* res) {
  std::vector<bool> flags = res->get_is_unsigned_int();
  cpp11::writable::logicals out(static_cast<R_xlen_t>(flags.size()));
  for (size_t i = 0; i < flags.size(); ++i) {
    out[static_cast<R_xlen_t>(i)] = static_cast<bool>(flags[i]);
  }
  return out;
}
