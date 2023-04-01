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
  MY_LGL     // for BIT(1)
};

MariaFieldType variable_type_from_field_type(enum_field_types type, bool binary, bool length1);
std::string type_name(MariaFieldType type);
SEXPTYPE type_sexp(MariaFieldType type);

std::string r_class(const cpp11::sexp& x);
MariaFieldType variable_type_from_object(const cpp11::sexp& type);


#endif
