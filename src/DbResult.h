#ifndef __RMARIADB_MARIA_RESULT__
#define __RMARIADB_MARIA_RESULT__

#include "DbConnection.h"

class DbResult : boost::noncopyable {
protected:
  DbResult(DbConnectionPtr maria_conn_);

public:
  virtual ~DbResult();

public:
  virtual void send_query(const std::string& sql) = 0;
  virtual void close() = 0;

  virtual void bind(List params) = 0;

  virtual List get_column_info() = 0;

  virtual List fetch(int n_max = -1) = 0;

  virtual int n_rows_affected() = 0;
  virtual int n_rows_fetched() = 0;
  virtual bool complete() = 0;

public:
  bool active() const;

protected:
  void set_current_result();
  void clear_current_result();
  MYSQL* get_conn() const;

  void exec(const std::string& sql);
  void autocommit();

public:
  static DbResult* create_and_send_query(DbConnectionPtr con, const std::string& sql, bool is_statement);

private:
  DbConnectionPtr maria_conn;
};

#endif
