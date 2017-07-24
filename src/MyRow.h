#ifndef __RMYSQL_MY_ROW__
#define __RMYSQL_MY_ROW__

#include <boost/core/noncopyable.hpp>
#include "MyTypes.h"

class MyRow : public boost::noncopyable {
  MYSQL_STMT* pStatement_;

  int n_;
  std::vector<MYSQL_BIND> bindings_;

  std::vector<MyFieldType> types_;
  std::vector<std::vector<unsigned char> > buffers_;
  std::vector<unsigned long> lengths_;
  std::vector<my_bool> nulls_, errors_;

public:
  MyRow();
  ~MyRow();

public:
  void setUp(MYSQL_STMT* pStatement, std::vector<MyFieldType> types);

  // Value accessors -----------------------------------------------------------
  bool isNull(int j);

  int valueInt(int j);
  int valueInt64(int j);
  double valueDouble(int j);
  SEXP valueString(int j);
  SEXP valueRaw(int j);
  double valueDateTime(int j);
  int valueDate(int j);
  int valueTime(int j);

  void setListValue(SEXP x, int i, int j);

private:
  void fetchBuffer(int j);
};

#endif
