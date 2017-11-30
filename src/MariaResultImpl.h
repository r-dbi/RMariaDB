#ifndef RMARIADB_MARIARESULTIMPL_H
#define RMARIADB_MARIARESULTIMPL_H

class MariaResultImpl {
public:
  MariaResultImpl();
  virtual ~MariaResultImpl();

public:
  virtual void send_query(const std::string& sql) = 0;
  virtual void close() = 0;

  virtual void bind(const List& params) = 0;

  virtual List get_column_info() = 0;

  virtual List fetch(int n_max = -1) = 0;

  virtual int n_rows_affected() = 0;
  virtual int n_rows_fetched() = 0;
  virtual bool complete() = 0;
};

#endif //RMARIADB_MARIARESULTIMPL_H
