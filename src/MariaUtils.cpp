#include "pch.h"
#include "MariaTypes.h"

List dfResize(const List& df, int n) {
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

void dfS3(const List& df, const std::vector<MariaFieldType>& types) {
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
    default:
      break;
    }

  }
}

List dfCreate(const std::vector<MariaFieldType>& types, const std::vector<std::string>& names, int n) {
  R_xlen_t p = types.size();

  List out(p);
  out.attr("names") = names;
  out.attr("class") = "data.frame";
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -n);

  for (R_xlen_t j = 0; j < p; ++j) {
    out[j] = Rf_allocVector(typeSEXP(types[j]), n);
  }
  return out;
}
