#include "pch.h"

#include "MariaResultSimple.h"

MariaResultSimple::MariaResultSimple(MariaConnectionPtr conn) :
  MariaResult(conn)
{
  set_current_result();
}

MariaResultSimple::~MariaResultSimple() {
  try {
    clear_current_result();
    close();
  } catch (...) {};
}

void MariaResultSimple::send_query(const std::string& sql) {
  LOG_DEBUG << sql;

  exec(sql);
}

void MariaResultSimple::close() {
  LOG_VERBOSE;
}

void MariaResultSimple::bind(List /*params*/) {
  LOG_VERBOSE;

  stop("This query is not supported by the prepared statement protocol, no parameters can be bound.");
}

List MariaResultSimple::column_info() {
  CharacterVector names(0), types(0);

  List out = List::create(names, types);
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, 0);
  out.attr("class") = "data.frame";
  out.attr("names") = CharacterVector::create("name", "type");

  return out;
}

List MariaResultSimple::fetch(int /*n_max*/) {
  LOG_VERBOSE;

  warning("Use dbExecute() instead of dbGetQuery() for statements, and also avoid dbFetch()");
  return df_create(std::vector<MariaFieldType>(), std::vector<std::string>(), 0);
}

int MariaResultSimple::rows_affected() {
  return 0;
}

int MariaResultSimple::rows_fetched() {
  return 0;
}

bool MariaResultSimple::complete() {
  return true;
}
