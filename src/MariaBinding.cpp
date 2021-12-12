#include "pch.h"
#include <math.h>
#include "MariaBinding.h"
#include "integer64.h"

MariaBinding::MariaBinding() :
  statement(NULL),
  p(0),
  i(0),
  n_rows(0) {
}

MariaBinding::~MariaBinding() {
}

void MariaBinding::setup(MYSQL_STMT* statement_) {
  LOG_VERBOSE;

  statement = statement_;
  p = static_cast<int>(mysql_stmt_param_count(statement));

  bindings.resize(p);
  types.resize(p);
  is_null.resize(p);
  time_buffers.resize(p);
}

void MariaBinding::init_binding(const List& params_) {
  LOG_VERBOSE;

  params = params_;

  if (params.size() == 0) {
    stop("Query has no parameters");
  }

  if (p != params.size()) {
    stop("Number of params don't match (%i vs %i)", p, params.size());
  }

  i = 0;

  for (int j = 0; j < p; ++j) {
    RObject param(params[j]);
    MariaFieldType type = variable_type_from_object(param);
    types[j] = type;

    LOG_VERBOSE << j << " -> " << type_name(type);

    if (j == 0) {
      n_rows = Rf_xlength(param);
    }

    switch (type) {
    case MY_LGL:
      binding_update(j, MYSQL_TYPE_TINY, 1);
      break;
    case MY_INT32:
      binding_update(j, MYSQL_TYPE_LONG, 4);
      break;
    case MY_DBL:
      binding_update(j, MYSQL_TYPE_DOUBLE, 8);
      break;
    case MY_DATE:
      binding_update(j, MYSQL_TYPE_DATE, sizeof(MYSQL_TIME));
      break;
    case MY_DATE_TIME:
      binding_update(j, MYSQL_TYPE_DATETIME, sizeof(MYSQL_TIME));
      break;
    case MY_TIME:
      binding_update(j, MYSQL_TYPE_TIME, sizeof(MYSQL_TIME));
      break;
    case MY_STR:
      binding_update(j, MYSQL_TYPE_STRING, 0);
      break;
    case MY_RAW:
      binding_update(j, MYSQL_TYPE_BLOB, 0);
      break;
    case MY_INT64:
      binding_update(j, MYSQL_TYPE_LONGLONG, 0);
      break;
    }
  }
}

bool MariaBinding::bind_next_row() {
  LOG_VERBOSE;

  if (i >= n_rows) return false;

  for (int j = 0; j < p; ++j) {
    LOG_VERBOSE << j << " -> " << type_name(types[j]);

    bool missing = false;
    RObject col(params[j]);

    switch (types[j]) {
    case MY_LGL:
      if (LOGICAL(col)[i] == NA_LOGICAL) {
        missing = true;
        break;
      }
      bindings[j].buffer = &LOGICAL(col)[i];
      break;
    case MY_INT32:
      if (INTEGER(col)[i] == NA_INTEGER) {
        missing = true;
        break;
      }
      bindings[j].buffer = &INTEGER(col)[i];
      break;
    case MY_DBL:
      if (ISNA(REAL(col)[i])) {
        missing = true;
        break;
      }
      bindings[j].buffer = &REAL(col)[i];
      break;
    case MY_STR:
      if (STRING_ELT(col, i) == NA_STRING) {
        missing = true;
        break;
      } else {
        SEXP string = STRING_ELT(col, i);
        bindings[j].buffer = const_cast<char*>(CHAR(string));
        bindings[j].buffer_length = Rf_length(string);
      }
      break;
    case MY_RAW:
      {
        SEXP raw = VECTOR_ELT(col, i);
        if (Rf_isNull(raw)) {
          missing = true;
        } else {
          bindings[j].buffer_length = Rf_length(raw);
          bindings[j].buffer = RAW(raw);
        }
        break;
      }
    case MY_DATE:
    case MY_DATE_TIME:
      if (ISNAN(REAL(col)[i])) {
        missing = true;
      } else {
        double val = REAL(col)[i];
        LOG_VERBOSE << val;
        if (types[j] == MY_DATE) {
          set_date_buffer(j, static_cast<int>(::floor(val)));
          clear_time_buffer(j);
        } else {
          double days = ::floor(val / 86400.0);
          set_date_buffer(j, static_cast<int>(days));
          set_time_buffer(j, val - days * 86400.0);
        }
        LOG_VERBOSE;
        bindings[j].buffer_length = sizeof(MYSQL_TIME);
        bindings[j].buffer = &time_buffers[j];
      }
      break;
    case MY_TIME:
      if (ISNAN(REAL(col)[i])) {
        missing = true;
        break;
      } else {
        double val = REAL(col)[i];
        clear_date_buffer(j);
        set_time_buffer(j, val);
        bindings[j].buffer_length = sizeof(MYSQL_TIME);
        bindings[j].buffer = &time_buffers[j];
      }
      break;
    case MY_INT64:
      if (INTEGER64(col)[i] == NA_INTEGER64) {
        missing = true;
        break;
      }
      bindings[j].buffer = &INTEGER64(col)[i];
      break;
    }
    is_null[j] = missing;
  }

  LOG_DEBUG << "Binding";
  mysql_stmt_bind_param(statement, &bindings[0]);

  LOG_DEBUG << "Done binding row " << i;
  i++;
  return true;
}

void MariaBinding::binding_update(int j, enum_field_types type, int size) {
  LOG_VERBOSE << j << ", " << type << ", " << size;

  bindings[j].buffer_length = size;
  bindings[j].buffer_type = type;
  bindings[j].is_null = &is_null[j];
}

void MariaBinding::clear_date_buffer(int j) {
  LOG_VERBOSE << j;
  time_buffers[j].year = 0;
  time_buffers[j].month = 0;
  time_buffers[j].day = 0;
}

void MariaBinding::set_date_buffer(int j, const int date) {
  LOG_VERBOSE << date;

  // https://howardhinnant.github.io/date_algorithms.html#civil_from_days
  const int date_0 = date + 719468;
  const int era = (date_0 >= 0 ? date_0 : date_0 - 146096) / 146097;
  const unsigned doe = static_cast<unsigned>(date_0 - era * 146097);          // [0, 146096]
  LOG_VERBOSE << doe;
  const unsigned yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365;  // [0, 399]
  LOG_VERBOSE << yoe;
  const int y = static_cast<int>(yoe) + era * 400;
  const unsigned doy = doe - (365*yoe + yoe/4 - yoe/100);                // [0, 365]
  const unsigned mp = (5*doy + 2)/153;                                   // [0, 11]
  const unsigned d = doy - (153*mp+2)/5 + 1;                             // [1, 31]
  const unsigned m = mp < 10 ? mp+3 : mp-9;                              // [1, 12]
  const unsigned yr = y + (m <= 2);

  // gmtime() fails for dates < 1970 on Windows
  LOG_VERBOSE << date_0;
  LOG_VERBOSE << yr;
  LOG_VERBOSE << m;
  LOG_VERBOSE << d;

  time_buffers[j].year = yr;
  time_buffers[j].month = m;
  time_buffers[j].day = d;
}

void MariaBinding::clear_time_buffer(int j) {
  LOG_VERBOSE << j;
  time_buffers[j].hour = 0;
  time_buffers[j].minute = 0;
  time_buffers[j].second = 0;
  time_buffers[j].second_part = 0;
  time_buffers[j].neg = 0;
}

void MariaBinding::set_time_buffer(int j, double time) {
  LOG_VERBOSE << time;

  bool neg = false;
  if (time < 0) {
    neg = true;
    time = -time;
  }
  double whole_seconds = ::trunc(time);
  double frac_seconds = time - whole_seconds;
  double whole_minutes = ::trunc(time / 60.0);
  double seconds = whole_seconds - whole_minutes * 60.0;
  double hours = ::trunc(time / 3600.0);
  double minutes = whole_minutes - hours * 60.0;

  time_buffers[j].hour = static_cast<unsigned int>(hours);
  time_buffers[j].minute = static_cast<unsigned int>(minutes);
  time_buffers[j].second = static_cast<unsigned int>(seconds);
  time_buffers[j].second_part = static_cast<unsigned long>(frac_seconds * 1000000.0);
  time_buffers[j].neg = neg;
}
