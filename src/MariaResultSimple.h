#ifndef __RMARIADB_MARIA_RESULT_SIMPLE__
#define __RMARIADB_MARIA_RESULT_SIMPLE__

#include <boost/noncopyable.hpp>
#include "MariaBinding.h"
#include "DbResult.h"
#include "MariaResultImpl.h"
#include "MariaRow.h"
#include "MariaTypes.h"
#include "MariaUtils.h"

class DbConnection;
typedef boost::shared_ptr<DbConnection> DbConnectionPtr;

class MariaResultSimple : boost::noncopyable, public MariaResultImpl {
  DbConnectionPtr pConn_;

public:
  MariaResultSimple(const DbConnectionPtr& pConn, bool is_statement);
  ~MariaResultSimple();

public:
  virtual void send_query(const std::string& sql);
  virtual void close();

  virtual void bind(const cpp11::list& params);

  virtual cpp11::writable::list get_column_info();

  virtual cpp11::list fetch(int n_max = -1);

  virtual int n_rows_affected();
  virtual int n_rows_fetched();
  virtual bool complete() const;

private:
  void exec(const std::string& sql);
};

#endif
