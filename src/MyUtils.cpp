#include "pch.h"
#include "MyTypes.h"

Rcpp::List dfResize(const Rcpp::List& df, int n) {
  int p = df.size();

  Rcpp::List out(p);
  for (int j = 0; j < p; ++j) {
    out[j] = Rf_lengthgets(df[j], n);
  }

  out.attr("names") = df.attr("names");
  out.attr("class") = df.attr("class");
  out.attr("row.names") = Rcpp::IntegerVector::create(NA_INTEGER, -n);

  return out;
}

void dfS3(const Rcpp::List& df, const std::vector<MyFieldType>& types) {
  int p = df.size();

  for (int j = 0; j < p; ++j) {
    Rcpp::RObject col = df[j];
    switch (types[j]) {
    case MY_DATE:
      col.attr("class") = Rcpp::CharacterVector::create("Date");
      break;
    case MY_DATE_TIME:
      col.attr("class") = Rcpp::CharacterVector::create("POSIXct", "POSIXt");
      break;
    default:
      break;
    }

  }
}

Rcpp::List dfCreate(const std::vector<MyFieldType>& types, const std::vector<std::string>& names, int n) {
  int p = types.size();

  Rcpp::List out(p);
  out.attr("names") = names;
  out.attr("class") = "data.frame";
  out.attr("row.names") = Rcpp::IntegerVector::create(NA_INTEGER, -n);

  for (int j = 0; j < p; ++j) {
    out[j] = Rf_allocVector(typeSEXP(types[j]), n);
  }
  return out;
}
