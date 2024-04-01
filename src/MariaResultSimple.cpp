#include "pch.h"

#include "MariaResultSimple.h"
#include "DbConnection.h"

MariaResultSimple::MariaResultSimple(const DbConnectionPtr& pConn, bool is_statement) :
  pConn_(pConn)
{
  (void)is_statement;
}

MariaResultSimple::~MariaResultSimple() {
  MariaResultSimple::close();
}

void MariaResultSimple::send_query(const std::string& sql) {
  LOG_DEBUG << sql;

  exec(sql);
}

void MariaResultSimple::close() {
  LOG_VERBOSE;
}

void MariaResultSimple::bind(const cpp11::list& /*params*/) {
  LOG_VERBOSE;

  cpp11::stop("This query is not supported by the prepared statement protocol, no parameters can be bound.");
}

cpp11::list MariaResultSimple::get_column_info() {
  using namespace cpp11::literals;
  cpp11::writable::strings names(0_xl), types(0_xl);

  return cpp11::writable::list({"name"_nm = names, "type"_nm = types});
}

cpp11::list MariaResultSimple::fetch(int /*n_max*/) {
  LOG_VERBOSE;

  cpp11::warning("Use dbExecute() instead of dbGetQuery() for statements, and also avoid dbFetch()");
  return df_create(std::vector<MariaFieldType>(), std::vector<std::string>(), 0);
}

int MariaResultSimple::n_rows_affected() {
  return 0;
}

int MariaResultSimple::n_rows_fetched() {
  return 0;
}

bool MariaResultSimple::complete() const {
  return true;
}

void MariaResultSimple::exec(const std::string& sql) {
  pConn_->exec(sql);
}
