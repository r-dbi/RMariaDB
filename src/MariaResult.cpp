#include "pch.h"

#include "MariaResult.h"
#include "MariaResultPrep.h"

MariaResult::~MariaResult() {
}

MariaResult* MariaResult::create(MariaConnectionPtr con, const std::string& sql) {
  return new MariaResultPrep(con, sql);
}
