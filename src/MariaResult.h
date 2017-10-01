#ifndef __RMARIADB_MARIA_RESULT__
#define __RMARIADB_MARIA_RESULT__

#include "MariaConnection.h"

class MariaResult {
public:
  virtual ~MariaResult();

  virtual void send_query(std::string sql) = 0;
  virtual void close() = 0;

  virtual void bind(List params) = 0;

  virtual List column_info() = 0;

  virtual List fetch(int n_max = -1) = 0;

  virtual int rows_affected() = 0;
  virtual int rows_fetched() = 0;
  virtual bool complete() = 0;
  virtual bool active() = 0;

public:
  static MariaResult* create_and_send_query(MariaConnectionPtr con, const std::string& sql);
};

#endif
