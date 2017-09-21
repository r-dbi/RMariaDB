#include "pch.h"

#include "MariaResult.h"
#include "MariaConnection.h"

MariaResult::MariaResult(MariaConnectionPtr pConn) :
  pConn_(pConn),
  pStatement_(NULL),
  pSpec_(NULL),
  rowsAffected_(0),
  rowsFetched_(0),
  bound_(false),
  complete_(false)
{
  pStatement_ = mysql_stmt_init(pConn->conn());
  if (pStatement_ == NULL)
    stop("Out of memory");
  pConn_->set_current_result(this);
}

MariaResult::~MariaResult() {
  try {
    pConn_->set_current_result(NULL);
    close();
  } catch (...) {};
}

void MariaResult::send_query(std::string sql) {
  if (mysql_stmt_prepare(pStatement_, sql.data(), sql.size()) != 0)
    throw_error();

  nParams_ = static_cast<int>(mysql_stmt_param_count(pStatement_));
  if (nParams_ == 0) {
    // Not parameterised so we can execute immediately
    execute();
  }

  pSpec_ = mysql_stmt_result_metadata(pStatement_);
  if (pSpec_ != NULL) {
    // Query returns results, so cache column names and types
    cache_metadata();
    bindingOutput_.setup(pStatement_, types_);
  }
}

void MariaResult::close() {
  if (pSpec_ != NULL) {
    mysql_free_result(pSpec_);
    pSpec_ = NULL;
  }

  if (pStatement_ != NULL) {
    mysql_stmt_close(pStatement_);
    pStatement_ = NULL;
  }

  pConn_->autocommit();
}

void MariaResult::execute() {
  complete_ = false;
  rowsFetched_ = 0;
  bound_ = true;

  if (mysql_stmt_execute(pStatement_) != 0)
    throw_error();
  rowsAffected_ = mysql_stmt_affected_rows(pStatement_);
}

void MariaResult::bind(List params) {
  bindingInput_.setup(pStatement_);
  bindingInput_.init_binding(params);
  bindingInput_.bind_row(params, 0);
  execute();
}

void MariaResult::bind_rows(List params) {
  if (params.size() == 0)
    return;

  bindingInput_.setup(pStatement_);
  bindingInput_.init_binding(params);

  int n = Rf_length(params[0]);
  for (int i = 0; i < n; ++i) {
    bindingInput_.bind_row(params, i);
    execute();
  }
}

List MariaResult::column_info() {
  CharacterVector names(nCols_), types(nCols_);
  for (int i = 0; i < nCols_; i++) {
    names[i] = names_[i];
    types[i] = typeName(types_[i]);
  }

  List out = List::create(names, types);
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -nCols_);
  out.attr("class") = "data.frame";
  out.attr("names") = CharacterVector::create("name", "type");

  return out;
}

bool MariaResult::fetch_row() {
  int result = mysql_stmt_fetch(pStatement_);

  switch (result) {
  // We expect truncation whenever there's a string or blob
  case MYSQL_DATA_TRUNCATED:
  case 0:
    rowsFetched_++;
    return true;
  case 1:
    throw_error();
  case MYSQL_NO_DATA:
    complete_ = true;
    rowsFetched_++;
    return false;
  }
  return false;
}

List MariaResult::fetch(int n_max) {
  if (!bound_)
    stop("Query needs to be bound before fetching");
  if (!active())
    stop("Inactive result set");
  if (pSpec_ == NULL) {
    if (names_.size() == 0) {
      warning("Use dbExecute() instead of dbGetQuery() for statements, and also avoid dbFetch()");
    }
    return dfCreate(types_, names_, 0);
  }

  int n = (n_max < 0) ? 100 : n_max;
  List out = dfCreate(types_, names_, n);
  if (n == 0)
    return out;

  int i = 0;

  if (rowsFetched_ == 0) {
    fetch_row();
  }

  while (!complete_) {
    if (i >= n) {
      if (n_max < 0) {
        n *= 2;
        out = dfResize(out, n);
      } else {
        break;
      }
    }

    for (int j = 0; j < nCols_; ++j) {
      // Rcout << i << "," << j << "\n";
      bindingOutput_.set_list_value(out[j], i, j);
    }

    fetch_row();
    ++i;
    if (i % 1000 == 0)
      checkUserInterrupt();
  }

  // Trim back to what we actually used
  if (i < n) {
    out = dfResize(out, i);
  }
  // Set up S3 classes
  dfS3(out, types_);

  return out;
}

int MariaResult::rows_affected() {
  // FIXME: > 2^32 rows?
  return static_cast<int>(rowsAffected_);
}

int MariaResult::rows_fetched() {
  // FIXME: > 2^32 rows?
  return static_cast<int>(rowsFetched_ == 0 ? 0 : rowsFetched_ - 1);
}

bool MariaResult::complete() {
  return
    (pSpec_ == NULL) || // query doesn't have results
    complete_;          // we've fetched all available results
}

bool MariaResult::active() {
  return pConn_->is_current_result(this);
}

void MariaResult::throw_error() {
  stop(
    "%s [%i]",
    mysql_stmt_error(pStatement_),
    mysql_stmt_errno(pStatement_)
  );
}

void MariaResult::cache_metadata() {
  nCols_ = mysql_num_fields(pSpec_);
  MYSQL_FIELD* fields = mysql_fetch_fields(pSpec_);

  for (int i = 0; i < nCols_; ++i) {
    names_.push_back(fields[i].name);

    bool binary = fields[i].charsetnr == 63;
    MariaFieldType type = variableType(fields[i].type, binary);
    types_.push_back(type);
  }
}
