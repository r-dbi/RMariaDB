#ifndef __RMARIADB_MARIA_RESULT__
#define __RMARIADB_MARIA_RESULT__

#include "DbConnection.h"

#include <boost/noncopyable.hpp>
#include <boost/scoped_ptr.hpp>

class MariaResultImpl;

class DbResult : boost::noncopyable {
  DbConnectionPtr maria_conn;
  boost::scoped_ptr<MariaResultImpl> impl;

public:
  DbResult(DbConnectionPtr maria_conn_);
  virtual ~DbResult();

public:
  void send_query(const std::string& sql, bool is_statement);
  void close();

  bool complete();
  bool active() const;

  void bind(List params);

  List get_column_info();

  List fetch(int n_max = -1);

  int n_rows_affected();
  int n_rows_fetched();

public:
  DbConnection* get_db_conn() const;
  MYSQL* get_conn() const;

protected:
  void set_current_result();
  void clear_current_result();

  void autocommit();

public:
  static DbResult* create_and_send_query(DbConnectionPtr con, const std::string& sql, bool is_statement);
};

#endif
