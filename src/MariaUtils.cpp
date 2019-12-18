#include "pch.h"
#include "MariaTypes.h"

List df_resize(const List& df, int n) {
  R_xlen_t p = df.size();

  List out(p);
  for (R_xlen_t j = 0; j < p; ++j) {
    out[j] = Rf_lengthgets(df[j], n);
  }

  out.attr("names") = df.attr("names");
  out.attr("class") = df.attr("class");
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -n);

  return out;
}

void df_s3(const List& df, const std::vector<MariaFieldType>& types) {
  R_xlen_t p = df.size();

  for (R_xlen_t j = 0; j < p; ++j) {
    RObject col(df[j]);
    switch (types[j]) {
    case MY_DATE:
      col.attr("class") = CharacterVector::create("Date");
      break;
    case MY_DATE_TIME:
      col.attr("class") = CharacterVector::create("POSIXct", "POSIXt");
      break;
    case MY_TIME:
      col.attr("class") = CharacterVector::create("hms", "difftime");
      col.attr("units") = "secs";
      break;
    case MY_INT64:
      col.attr("class") = CharacterVector::create("integer64");
      break;
    default:
      break;
    }

  }
}

List df_create(const std::vector<MariaFieldType>& types, const std::vector<std::string>& names, int n) {
  R_xlen_t p = types.size();

  List out(p);
  StringVector names_utf8 = wrap(names);
  for (int j = 0; j < names_utf8.size(); ++j) {
    names_utf8[j] = Rf_mkCharCE(names_utf8[j], CE_UTF8);
  }
  out.attr("names") = names_utf8;
  out.attr("class") = "data.frame";
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -n);

  for (R_xlen_t j = 0; j < p; ++j) {
    out[j] = Rf_allocVector(type_sexp(types[j]), n);
  }
  return out;
}

// From https://stackoverflow.com/a/40914871/946850:
int days_from_civil(int y, int m, int d) {
  y -= m <= 2;
  const int era = (y >= 0 ? y : y - 399) / 400;
  const int yoe = static_cast<unsigned>(y - era * 400);           // [0, 399]
  const int doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1; // [0, 365]
  const int doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;          // [0, 146096]
  return era * 146097 + doe - 719468;
}
