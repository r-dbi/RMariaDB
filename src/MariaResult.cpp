#include "pch.h"

#include "MariaResult.h"
#include "MariaResultPrep.h"

MariaResult::~MariaResult() {
}

MariaResult* MariaResult::create_and_send_query(MariaConnectionPtr con, const std::string& sql) {
  std::auto_ptr<MariaResult> res(new MariaResultPrep(con));
  try {
    res->send_query(sql);
  }
  catch (MariaResultPrep::UnsupportedPS e) {
    stop("Not yet implemented");
  }

  return res.release();
}
