#include "pch.h"

#ifndef __RMARIADB_TYPES__
#define __RMARIADB_TYPES__

#include "DbConnection.h"
#include "DbResult.h"
#include "MariaBinding.h"

namespace Rcpp {

template<>
DbConnection* as(SEXP x);

template<>
DbResult* as(SEXP x);

}

#endif
