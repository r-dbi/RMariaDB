#include "pch.h"
#include <ctime>

#if defined(WIN32) || defined(_WIN32) || defined(sun)
#define timegm _mkgmtime
#endif

#include "MariaRow.h"
#include "MariaTypes.h"
#include "integer64.h"


MariaRow::MariaRow() :
  pStatement_(NULL),
  n_(0)
{
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

  for (int j = 0; j < n_; ++j) {
    LOG_VERBOSE << j << " -> " << type_name(types_[j]);

    // http://dev.mysql.com/doc/refman/5.0/en/c-api-prepared-statement-type-codes.html
    switch (types_[j]) {
    case MY_INT32:
      bindings_[j].buffer_type = MYSQL_TYPE_LONG;
      buffers_[j].resize(4);
      break;
    case MY_INT64:
      bindings_[j].buffer_type = MYSQL_TYPE_LONGLONG;
      buffers_[j].resize(8);
      break;
    case MY_DBL:
      bindings_[j].buffer_type = MYSQL_TYPE_DOUBLE;
      buffers_[j].resize(8);
      break;
    case MY_DATE:
      bindings_[j].buffer_type = MYSQL_TYPE_DATE;
      buffers_[j].resize(sizeof(MYSQL_TIME));
      break;
    case MY_DATE_TIME:
      bindings_[j].buffer_type = MYSQL_TYPE_DATETIME;
      buffers_[j].resize(sizeof(MYSQL_TIME));
      break;
    case MY_TIME:
      bindings_[j].buffer_type = MYSQL_TYPE_TIME;
      buffers_[j].resize(sizeof(MYSQL_TIME));
      break;
    case MY_STR:
      bindings_[j].buffer_type = MYSQL_TYPE_STRING;
      buffers_[j].resize(0);
      // buffers might be arbitrary length, so leave size and use
      // alternative strategy: see fetch_buffer() for details
      break;
    case MY_RAW:
      bindings_[j].buffer_type = MYSQL_TYPE_BLOB;
      buffers_[j].resize(0);
      // buffers might be arbitrary length, so leave size and use
      // alternative strategy: see fetch_buffer() for details
      break;
    case MY_LGL:
      // input only
      break;
    }

    lengths_[j] = buffers_[j].size();
    bindings_[j].buffer_length = buffers_[j].size();
    if (bindings_[j].buffer_length > 0)
      bindings_[j].buffer = &buffers_[j][0];
    else
      bindings_[j].buffer = NULL;
    bindings_[j].length = &lengths_[j];
    bindings_[j].is_null = &nulls_[j];
    bindings_[j].is_unsigned = true;
    bindings_[j].error = &errors_[j];

    LOG_VERBOSE << bindings_[j].buffer_length;
    LOG_VERBOSE << bindings_[j].buffer;
    LOG_VERBOSE << bindings_[j].length;
    LOG_VERBOSE << (void*)bindings_[j].is_null;
    LOG_VERBOSE << bindings_[j].is_unsigned;
    LOG_VERBOSE << (void*)bindings_[j].error;
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

  int len = static_cast<int>(buffers_[j].size());
  if (len == 0)
    return R_BlankString;

  const char* val = reinterpret_cast<const char*>(&buffers_[j][0]);
  return Rf_mkCharLenCE(val, len, CE_UTF8);
}

SEXP MariaRow::value_raw(int j) {
  if (is_null(j))
    return R_NilValue;

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
  double date_time = static_cast<double>(timegm(&t)) + split_seconds;
  LOG_VERBOSE << date_time;
  return date_time;
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
  fetch_buffer(j);

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
  LOG_DEBUG << "mysql_stmt_fetch_column()";
  int result = mysql_stmt_fetch_column(pStatement_, &bindings_[j], j, 0);
  LOG_VERBOSE << result;

  if (result != 0)
    stop("Error fetching buffer: %s", mysql_stmt_error(pStatement_));

  if (bindings_[j].buffer)
    return;

  unsigned long length = lengths_[j];
  LOG_VERBOSE << length;

  if (length == 0)
    return;

  buffers_[j].resize(length);
  bindings_[j].buffer = &buffers_[j][0]; // might have moved
  bindings_[j].buffer_length = length;

  LOG_VERBOSE << bindings_[j].buffer_length;
  LOG_VERBOSE << bindings_[j].buffer;
  LOG_VERBOSE << bindings_[j].length;
  LOG_VERBOSE << (void*)bindings_[j].is_null;
  LOG_VERBOSE << bindings_[j].is_unsigned;
  LOG_VERBOSE << (void*)bindings_[j].error;

  LOG_DEBUG << "mysql_stmt_fetch_column()";
  result = mysql_stmt_fetch_column(pStatement_, &bindings_[j], j, 0);
  LOG_VERBOSE << result;

  if (result != 0)
    stop("Error fetching buffer: %s", mysql_stmt_error(pStatement_));

  // Reset buffer length to zero for next row
  bindings_[j].buffer = NULL;
  bindings_[j].buffer_length = 0;
}
