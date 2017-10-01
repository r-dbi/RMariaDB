#ifndef __RMARIADB_MARIA_RESULT_SIMPLE__
#define __RMARIADB_MARIA_RESULT_SIMPLE__

#include <boost/noncopyable.hpp>
#include "MariaConnection.h"
#include "MariaBinding.h"
#include "MariaResult.h"
#include "MariaRow.h"
#include "MariaTypes.h"
#include "MariaUtils.h"

class MariaResultSimple : boost::noncopyable, public MariaResult {
  MariaConnectionPtr pConn_;

public:
  MariaResultSimple(MariaConnectionPtr conn);
  ~MariaResultSimple();

public:
  virtual void send_query(const std::string& sql);
  virtual void close();

  virtual void bind(List params);

  virtual List column_info();

  virtual List fetch(int n_max = -1);

  virtual int rows_affected();
  virtual int rows_fetched();
  virtual bool complete();
};

#endif
