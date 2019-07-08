#include "pch.h"
#include "MariaResult.h"
#include "MariaResultPrep.h"
#include "MariaResultSimple.h"


// Construction ////////////////////////////////////////////////////////////////

MariaResult::MariaResult(const DbConnectionPtr& pConn, const std::string& sql, bool is_statement) :
  DbResult(pConn)
{
  send_query(sql, is_statement);
}

DbResult* MariaResult::create_and_send_query(const DbConnectionPtr& con, const std::string& sql, bool is_statement) {
  return new MariaResult(con, sql, is_statement);
}

// Publics /////////////////////////////////////////////////////////////////////

// Privates ///////////////////////////////////////////////////////////////////

void MariaResult::send_query(const std::string& sql, bool is_statement) {
  boost::scoped_ptr<MariaResultImpl> res(new MariaResultPrep(pConn_, is_statement));
  try {
    res->send_query(sql);
  }
  catch (MariaResultPrep::UnsupportedPS e) {
    res.reset(NULL);
    // is_statement info might be worthwhile to pass to simple queries as well
    res.reset(new MariaResultSimple(pConn_, is_statement));
    res->send_query(sql);
  }

  res.swap(impl);
}
