#ifndef __RMYSQL_MY_TYPES__
#define __RMYSQL_MY_TYPES__

enum MyFieldType {
  MY_INT32,
  MY_INT64,   // output only
  MY_DBL,
  MY_STR,
  MY_DATE,
  MY_DATE_TIME,
  MY_TIME,   // output only
  MY_RAW,
  MY_FACTOR, // input only
  MY_LGL     // input only
};

MyFieldType variableType(enum_field_types type, bool binary);
std::string typeName(MyFieldType type);
SEXPTYPE typeSEXP(MyFieldType type);

std::string rClass(Rcpp::RObject x);
MyFieldType variableType(Rcpp::RObject type);


#endif
