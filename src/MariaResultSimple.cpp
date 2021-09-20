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

void MariaResultSimple::bind(const List& /*params*/) {
  LOG_VERBOSE;

  stop("This query is not supported by the prepared statement protocol, no parameters can be bound.");
}

List MariaResultSimple::get_column_info() {
  CharacterVector names(0), types(0);

  return List::create(_["name"] = names, _["type"] = types);
}

List MariaResultSimple::fetch(int /*n_max*/) {
  LOG_VERBOSE;

  warning("Use dbExecute() instead of dbGetQuery() for statements, and also avoid dbFetch()");
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
