#ifndef RMARIADB_INTEGER64_H
#define RMARIADB_INTEGER64_H

#define INT64SXP REALSXP

#define NA_INTEGER64 (static_cast<int64_t>(0x8000000000000000))

inline int64_t* INTEGER64(SEXP x) {
  return reinterpret_cast<int64_t*>(REAL(x));
}

#endif // RMARIADB_INTEGER64_H
