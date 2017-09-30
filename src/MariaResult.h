#ifndef __RMARIADB_MARIA_RESULT__
#define __RMARIADB_MARIA_RESULT__

#include <boost/noncopyable.hpp>
#include "MariaConnection.h"
#include "MariaBinding.h"
#include "MariaRow.h"
#include "MariaTypes.h"
#include "MariaUtils.h"

class IMariaResult {
public:
  virtual ~IMariaResult();

  virtual void send_query(std::string sql) = 0;
  virtual void close() = 0;

  virtual void bind(List params) = 0;

  virtual List column_info() = 0;

  virtual List fetch(int n_max = -1) = 0;

  virtual int rows_affected() = 0;
  virtual int rows_fetched() = 0;
  virtual bool complete() = 0;
  virtual bool active() = 0;
};

class MariaResult : boost::noncopyable, public IMariaResult {
  MariaConnectionPtr pConn_;
  MYSQL_STMT* pStatement_;
  MYSQL_RES* pSpec_;
  uint64_t rowsAffected_, rowsFetched_;

  int nCols_, nParams_;
  bool bound_, complete_;

  std::vector<MariaFieldType> types_;
  std::vector<std::string> names_;
  MariaBinding bindingInput_;
  MariaRow bindingOutput_;

public:
  MariaResult(MariaConnectionPtr pConn);
  ~MariaResult();

public:
  virtual void send_query(std::string sql);
  virtual void close();

  virtual void bind(List params);

  virtual List column_info();

  virtual List fetch(int n_max = -1);

  virtual int rows_affected();
  virtual int rows_fetched();
  virtual bool complete();
  virtual bool active();

private:
  void execute();

  bool has_result() const;
  bool step();
  bool fetch_row();
  void throw_error();

private:
  void cache_metadata();
};

#endif
