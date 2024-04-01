#ifndef RMARIADB_MARIARESULTIMPL_H
#define RMARIADB_MARIARESULTIMPL_H

class MariaResultImpl {
public:
  MariaResultImpl();
  virtual ~MariaResultImpl();

public:
  virtual void send_query(const std::string& sql) = 0;
  virtual void close() = 0;

  virtual void bind(const cpp11::list& params) = 0;

  virtual cpp11::list get_column_info() = 0;

  virtual cpp11::list fetch(int n_max = -1) = 0;

  virtual int n_rows_affected() = 0;
  virtual int n_rows_fetched() = 0;
  virtual bool complete() const = 0;
};

#endif //RMARIADB_MARIARESULTIMPL_H
