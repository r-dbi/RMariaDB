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
  out.attr("names") = names;
  out.attr("class") = "data.frame";
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -n);

  for (R_xlen_t j = 0; j < p; ++j) {
    out[j] = Rf_allocVector(type_sexp(types[j]), n);
  }
  return out;
}
