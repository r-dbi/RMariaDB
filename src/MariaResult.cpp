#include "pch.h"
#include "MariaResult.h"
#include "MariaResultPrep.h"
#include "MariaResultSimple.h"


// Construction ////////////////////////////////////////////////////////////////

MariaResult::MariaResult(const DbConnectionPtr& pConn, const std::string& sql, bool is_statement, bool immediate) :
  DbResult(pConn)
{
  boost::scoped_ptr<MariaResultImpl> res;
  if (!immediate) {
    try {
      res.reset(new MariaResultPrep(pConn, is_statement));
      res->send_query(sql);
    }
    catch (const MariaResultPrep::UnsupportedPS& e) {
      immediate = TRUE;
      res.reset(NULL);
    }
  }

  // Resetting the immediate flag in the catch block above
  if (immediate) {
    // is_statement info might be worthwhile to pass to simple queries as well
    res.reset(new MariaResultSimple(pConn, is_statement));
    res->send_query(sql);
  }

  BOOST_ASSERT(res.get());

  res.swap(impl);
}

DbResult* MariaResult::create_and_send_query(const DbConnectionPtr& con, const std::string& sql, bool is_statement, bool immediate) {
  return new MariaResult(con, sql, is_statement, immediate);
}

// Publics /////////////////////////////////////////////////////////////////////

// Privates ///////////////////////////////////////////////////////////////////
