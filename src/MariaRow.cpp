#include "pch.h"
#include <ctime>

#ifdef WIN32
#define timegm _mkgmtime
#endif

#include "MariaRow.h"
#include "MariaTypes.h"
#include "integer64.h"

#include <plogr.h>


MariaRow::MariaRow() {
}

MariaRow::~MariaRow() {
}

void MariaRow::setup(MYSQL_STMT* pStatement, const std::vector<MariaFieldType>& types) {
  LOG_VERBOSE;

  pStatement_ = pStatement;
  types_ = types;
  n_ = static_cast<int>(types_.size());

  bindings_.resize(n_);
  buffers_.resize(n_);
  lengths_.resize(n_);
  nulls_.resize(n_);
  errors_.resize(n_);

  for (int i = 0; i < n_; ++i) {
    LOG_VERBOSE << i << " -> " << type_name(types_[i]);

    // http://dev.mysql.com/doc/refman/5.0/en/c-api-prepared-statement-type-codes.html
    switch (types_[i]) {
    case MY_INT32:
      bindings_[i].buffer_type = MYSQL_TYPE_LONG;
      buffers_[i].resize(4);
      break;
    case MY_INT64:
      bindings_[i].buffer_type = MYSQL_TYPE_LONGLONG;
      buffers_[i].resize(8);
      break;
    case MY_DBL:
      bindings_[i].buffer_type = MYSQL_TYPE_DOUBLE;
      buffers_[i].resize(8);
      break;
    case MY_DATE:
      bindings_[i].buffer_type = MYSQL_TYPE_DATE;
      buffers_[i].resize(sizeof(MYSQL_TIME));
      break;
    case MY_DATE_TIME:
      bindings_[i].buffer_type = MYSQL_TYPE_DATETIME;
      buffers_[i].resize(sizeof(MYSQL_TIME));
      break;
    case MY_TIME:
      bindings_[i].buffer_type = MYSQL_TYPE_TIME;
      buffers_[i].resize(sizeof(MYSQL_TIME));
      break;
    case MY_STR:
      bindings_[i].buffer_type = MYSQL_TYPE_STRING;
      buffers_[i].resize(0);
      // buffers might be arbitrary length, so leave size and use
      // alternative strategy: see fetch_buffer() for details
      break;
    case MY_RAW:
      bindings_[i].buffer_type = MYSQL_TYPE_BLOB;
      buffers_[i].resize(0);
      // buffers might be arbitrary length, so leave size and use
      // alternative strategy: see fetch_buffer() for details
      break;
    case MY_LGL:
      // input only
      break;
    }

    lengths_[i] = buffers_[i].size();
    bindings_[i].buffer_length = buffers_[i].size();
    if (bindings_[i].buffer_length > 0)
      bindings_[i].buffer = &buffers_[i][0];
    else
      bindings_[i].buffer = NULL;
    bindings_[i].length = &lengths_[i];
    bindings_[i].is_null = &nulls_[i];
    bindings_[i].is_unsigned = true;
    bindings_[i].error = &errors_[i];
  }

  if (mysql_stmt_bind_result(pStatement, &bindings_[0]) != 0) {
    stop(mysql_stmt_error(pStatement));
  }
}

bool MariaRow::is_null(int j) {
  return nulls_[j] == 1;
}

int MariaRow::value_int(int j) {
  return is_null(j) ? NA_INTEGER : *((int*) &buffers_[j][0]);
}

int64_t MariaRow::value_int64(int j) {
  return is_null(j) ? NA_INTEGER64 : *((int64_t*) &buffers_[j][0]);
}

double MariaRow::value_double(int j) {
  return is_null(j) ? NA_REAL : *((double*) &buffers_[j][0]);
}

SEXP MariaRow::value_string(int j) {
  if (is_null(j))
    return NA_STRING;

  fetch_buffer(j);
  buffers_[j].push_back('\0');  // ensure string is null terminated
  const char* val = reinterpret_cast<const char*>(&buffers_[j][0]);

  return Rf_mkCharCE(val, CE_UTF8);
}

SEXP MariaRow::value_raw(int j) {
  if (is_null(j))
    return R_NilValue;

  fetch_buffer(j);
  SEXP bytes = Rf_allocVector(RAWSXP, lengths_[j]);
  memcpy(RAW(bytes), &buffers_[j][0], lengths_[j]);

  return bytes;
}

double MariaRow::value_date_time(int j) {
  if (is_null(j))
    return NA_REAL;

  MYSQL_TIME* mytime = (MYSQL_TIME*) &buffers_[j][0];

  struct tm t = {};
  t.tm_year = mytime->year - 1900;
  t.tm_mon = mytime->month - 1;
  t.tm_mday = mytime->day;
  t.tm_hour = mytime->hour;
  t.tm_min = mytime->minute;
  t.tm_sec = mytime->second;

  double split_seconds = static_cast<double>(mytime->second_part) / 1000000.0;
  return static_cast<double>(timegm(&t)) + split_seconds;
}

double MariaRow::value_date(int j) {
  if (is_null(j))
    return NA_REAL;

  return value_date_time(j) / 86400.0;
}

double MariaRow::value_time(int j) {
  if (is_null(j))
    return NA_REAL;

  MYSQL_TIME* mytime = (MYSQL_TIME*) &buffers_[j][0];
  return static_cast<double>(mytime->hour * 3600 + mytime->minute * 60 + mytime->second);
}

void MariaRow::set_list_value(SEXP x, int i, int j) {
  switch (types_[j]) {
  case MY_INT32:
    INTEGER(x)[i] = value_int(j);
    break;
  case MY_INT64:
    INTEGER64(x)[i] = value_int64(j);
    break;
  case MY_DBL:
    REAL(x)[i] = value_double(j);
    break;
  case MY_DATE:
    REAL(x)[i] = value_date(j);
    break;
  case MY_DATE_TIME:
    REAL(x)[i] = value_date_time(j);
    break;
  case MY_TIME:
    REAL(x)[i] = value_time(j);
    break;
  case MY_STR:
    SET_STRING_ELT(x, i, value_string(j));
    break;
  case MY_RAW:
    SET_VECTOR_ELT(x, i, value_raw(j));
    break;
  case MY_LGL:
    // input only
    break;
  }
}

void MariaRow::fetch_buffer(int j) {
  unsigned long length = lengths_[j];
  LOG_VERBOSE << length;

  buffers_[j].resize(length);
  if (length == 0)
    return;

  bindings_[j].buffer = &buffers_[j][0]; // might have moved
  bindings_[j].buffer_length = length;

  int result = mysql_stmt_fetch_column(pStatement_, &bindings_[j], j, 0);
  LOG_VERBOSE << result;

  if (result != 0)
    stop(mysql_stmt_error(pStatement_));

  // Reset buffer length to zero for next row
  bindings_[j].buffer = NULL;
  bindings_[j].buffer_length = 0;
  lengths_[j] = 0;
}
