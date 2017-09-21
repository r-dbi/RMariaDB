#ifndef __RMARIADB_MARIA_RESULT__
#define __RMARIADB_MARIA_RESULT__

#include <boost/noncopyable.hpp>
#include "MariaConnection.h"
#include "MariaBinding.h"
#include "MariaRow.h"
#include "MariaTypes.h"
#include "MariaUtils.h"

class MariaResult : boost::noncopyable {
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
  void send_query(std::string sql);
  void close();

  void execute();

  void bind(List params);
  void bind_rows(List params);

  List column_info();

  List fetch(int n_max = -1);

  int rows_affected();
  int rows_fetched();
  bool complete();
  bool active();

private:
  bool fetch_row();
  void throw_error();

private:
  void cache_metadata();
};

#endif
