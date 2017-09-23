#include "pch.h"
#include "MariaTypes.h"

bool all_raw(SEXP x);

MariaFieldType variable_type_from_field_type(enum_field_types type, bool binary) {
  switch (type) {
  case MYSQL_TYPE_TINY:
  case MYSQL_TYPE_SHORT:
  case MYSQL_TYPE_LONG:
  case MYSQL_TYPE_INT24:
  case MYSQL_TYPE_YEAR:
    return MY_INT32;

  case MYSQL_TYPE_LONGLONG:
    return MY_INT64;

  case MYSQL_TYPE_DECIMAL:
  case MYSQL_TYPE_NEWDECIMAL:
  case MYSQL_TYPE_FLOAT:
  case MYSQL_TYPE_DOUBLE:
    return MY_DBL;
  case MYSQL_TYPE_TIMESTAMP:
  case MYSQL_TYPE_DATETIME:
  case MYSQL_TYPE_NEWDATE:
    return MY_DATE_TIME;
  case MYSQL_TYPE_DATE:
    return MY_DATE;
  case MYSQL_TYPE_TIME:
    return MY_TIME;
  case MYSQL_TYPE_BIT:
  case MYSQL_TYPE_ENUM:
  case MYSQL_TYPE_STRING:
  case MYSQL_TYPE_VAR_STRING:
  case MYSQL_TYPE_VARCHAR:
    return binary ? MY_RAW : MY_STR;
  case MYSQL_TYPE_BLOB:
  case MYSQL_TYPE_TINY_BLOB:
  case MYSQL_TYPE_MEDIUM_BLOB:
  case MYSQL_TYPE_LONG_BLOB:
    return binary ? MY_RAW : MY_STR;
  case MYSQL_TYPE_SET:
    return MY_STR;
  case MYSQL_TYPE_GEOMETRY:
    return MY_RAW;
  case MYSQL_TYPE_NULL:
    return MY_INT32;
  default:
    throw std::runtime_error("Unimplemented MAX_NO_FIELD_TYPES");
  }
}

std::string type_name(MariaFieldType type) {
  switch (type) {
  case MY_INT32:
    return "integer";
  case MY_INT64:
    return "integer64";
  case MY_DBL:
    return "double";
  case MY_STR:
    return "string";
  case MY_DATE:
    return "Date";
  case MY_DATE_TIME:
    return "POSIXct";
  case MY_TIME:
    return "hms";
  case MY_RAW:
    return "raw";
  case MY_LGL:
    return "logical";
  }
  throw std::runtime_error("Invalid typeName");
}

SEXPTYPE type_sexp(MariaFieldType type) {
  switch (type) {
  case MY_INT32:
    return INTSXP;
  case MY_INT64:
    return REALSXP;
  case MY_DBL:
    return REALSXP;
  case MY_STR:
    return STRSXP;
  case MY_DATE:
    return REALSXP;
  case MY_DATE_TIME:
    return REALSXP;
  case MY_TIME:
    return REALSXP;
  case MY_RAW:
    return VECSXP;
  case MY_LGL:
    return LGLSXP;
  }
  throw std::runtime_error("Invalid typeSEXP");
}

std::string r_class(RObject x) {
  RObject klass_(x.attr("class"));
  std::string klass;
  if (klass_ == R_NilValue)
    return "";

  CharacterVector klassv = as<CharacterVector>(klass_);
  return std::string(klassv[klassv.length() - 1]);
}

MariaFieldType variable_type_from_object(const RObject& type) {
  std::string klass = r_class(type);

  switch (TYPEOF(type)) {
  case LGLSXP:
    return MY_LGL;
  case INTSXP:
    return MY_INT32;
  case REALSXP:
    if (klass == "Date")     return MY_DATE;
    if (klass == "POSIXt")   return MY_DATE_TIME;
    if (klass == "difftime") return MY_TIME;
    if (klass == "integer64") return MY_INT64;
    return MY_DBL;
  case STRSXP:
    return MY_STR;
  case VECSXP:
    if (klass == "blob")     return MY_RAW;
    if (all_raw(type))       return MY_RAW;
    break;
  }

  stop("Unsupported column type %s", Rf_type2char(TYPEOF(type)));
  return MY_STR;
}

bool all_raw(SEXP x) {
  List xx(x);
  for (R_xlen_t i = 0; i < xx.length(); ++i) {
    switch (TYPEOF(xx[i])) {
    case RAWSXP:
    case NILSXP:
      break;

    default:
      return false;
    }
  }
  return true;
}
