#ifndef __RMARIADB_MARIA_RESULT_SIMPLE__
#define __RMARIADB_MARIA_RESULT_SIMPLE__

#include <boost/noncopyable.hpp>
#include "DbConnection.h"
#include "MariaBinding.h"
#include "DbResult.h"
#include "MariaRow.h"
#include "MariaTypes.h"
#include "MariaUtils.h"

class MariaResultSimple : boost::noncopyable, public DbResult {
  DbConnectionPtr pConn_;

public:
  MariaResultSimple(DbConnectionPtr conn);
  ~MariaResultSimple();

public:
  virtual void send_query(const std::string& sql);
  virtual void close();

  virtual void bind(List params);

  virtual List get_column_info();

  virtual List fetch(int n_max = -1);

  virtual int n_rows_affected();
  virtual int n_rows_fetched();
  virtual bool complete();
};

#endif
