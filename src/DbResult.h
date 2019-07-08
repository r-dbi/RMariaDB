#ifndef __RDBI_DB_RESULT__
#define __RDBI_DB_RESULT__

#include <boost/noncopyable.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/scoped_ptr.hpp>

#include "DbResultImplDecl.h"


class DbConnection;
typedef boost::shared_ptr<DbConnection> DbConnectionPtr;

// DbResult --------------------------------------------------------------------

class DbResult : boost::noncopyable {
  DbConnectionPtr pConn_;
  boost::scoped_ptr<DbResultImpl> impl;

public:
  DbResult(const DbConnectionPtr& pConn);
  ~DbResult();

public:
  static DbResult* create_and_send_query(const DbConnectionPtr& con, const std::string& sql, bool is_statement);

public:
  void close();

  bool complete() const;
  bool is_active() const;
  int n_rows_fetched();
  int n_rows_affected();

  void bind(const List& params);
  List fetch(int n_max = -1);

  List get_column_info();

public:
  DbConnection* get_db_conn() const;
  MYSQL* get_conn() const;

private:
  void validate_params(const List& params) const;
  void send_query(const std::string& sql, bool is_statement);
};

#endif // __RDBI_DB_RESULT__
