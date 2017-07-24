#ifndef __RMYSQL_MY_RESULT__
#define __RMYSQL_MY_RESULT__

#include <boost/noncopyable.hpp>
#include "MyConnection.h"
#include "MyBinding.h"
#include "MyRow.h"
#include "MyTypes.h"
#include "MyUtils.h"

class MyResult : boost::noncopyable {
  MyConnectionPtr pConn_;
  MYSQL_STMT* pStatement_;
  MYSQL_RES* pSpec_;
  uint64_t rowsAffected_, rowsFetched_;

  int nCols_, nParams_;
  bool bound_, complete_;

  std::vector<MyFieldType> types_;
  std::vector<std::string> names_;
  MyBinding bindingInput_;
  MyRow bindingOutput_;

public:
  MyResult(MyConnectionPtr pConn);
  ~MyResult();

public:
  void sendQuery(std::string sql);
  void close();

  void execute();

  void bind(List params);
  void bindRows(List params);

  List columnInfo();

  bool fetchRow();
  List fetch(int n_max = -1);

  int rowsAffected();
  int rowsFetched();
  bool complete();
  bool active();

  void throwError();

private:
  void cacheMetadata();
};

#endif
