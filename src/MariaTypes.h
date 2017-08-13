#ifndef __RMARIADB_MARIA_TYPES__
#define __RMARIADB_MARIA_TYPES__

enum MariaFieldType {
  MY_INT32,
  MY_INT64,   // output only
  MY_DBL,
  MY_STR,
  MY_DATE,
  MY_DATE_TIME,
  MY_TIME,
  MY_RAW,
  MY_FACTOR, // input only
  MY_LGL     // input only
};

MariaFieldType variableType(enum_field_types type, bool binary);
std::string typeName(MariaFieldType type);
SEXPTYPE typeSEXP(MariaFieldType type);

std::string rClass(RObject x);
MariaFieldType variableType(const RObject& type);


#endif
