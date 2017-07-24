#ifndef __RMYSQL_MY_BINDING__
#define __RMYSQL_MY_BINDING__

#include <boost/noncopyable.hpp>
#include "MyTypes.h"

class MyBinding : public boost::noncopyable {
  MYSQL_STMT* pStatement_;

  int p_;
  std::vector<MYSQL_BIND> bindings_;
  std::vector<my_bool> isNull_;
  std::vector<MyFieldType> types_;
  std::vector<MYSQL_TIME> timeBuffers_;

public:
  MyBinding();
  ~MyBinding();

public:
  void setUp(MYSQL_STMT* pStatement);

  void initBinding(List params);
  void bindRow(List params, int i);
  void bindingUpdate(int j, enum_field_types type, int size);

  void setTimeBuffer(int j, time_t time);
};

#endif
