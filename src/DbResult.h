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
  ~DbResult();

public:
  void close();

  bool complete();
  bool active() const;
  int n_rows_fetched();
  int n_rows_affected();

  void bind(const List& params);
  List fetch(int n_max = -1);

  List get_column_info();


public:
  DbConnection* get_db_conn() const;
  MYSQL* get_conn() const;

protected:
  void set_current_result();
  void clear_current_result();

private:
  void send_query(const std::string& sql, bool is_statement);

public:
  static DbResult* create_and_send_query(DbConnectionPtr con, const std::string& sql, bool is_statement);
};

#endif
