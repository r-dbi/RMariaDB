#include "pch.h"

#include "MariaResultPrep.h"
#include "DbConnection.h"
#include <mysqld_error.h>

MariaResultPrep::MariaResultPrep(DbResult* res, bool is_statement) :
  pRes_(res),
  pStatement_(NULL),
  pSpec_(NULL),
  rowsAffected_(0),
  rowsFetched_(0),
  nCols_(0),
  nParams_(0),
  bound_(false),
  complete_(false),
  is_statement_(is_statement)
{
  pStatement_ = mysql_stmt_init(pRes_->get_conn());
  if (pStatement_ == NULL)
    stop("Out of memory");
}

MariaResultPrep::~MariaResultPrep() {
  MariaResultPrep::close();
}

void MariaResultPrep::send_query(const std::string& sql) {
  LOG_DEBUG << sql;

  LOG_DEBUG << "mysql_stmt_prepare()";
  if (mysql_stmt_prepare(pStatement_, sql.data(), sql.size()) != 0) {
    if (mysql_stmt_errno(pStatement_) == ER_UNSUPPORTED_PS) {
      throw UnsupportedPS();
    }

    throw_error();
  }

  nParams_ = static_cast<int>(mysql_stmt_param_count(pStatement_));
  LOG_DEBUG << nParams_;

  // Need to set pSpec_ before calling execute()
  pSpec_ = mysql_stmt_result_metadata(pStatement_);

  if (nParams_ == 0) {
    // Not parameterised so we can execute immediately
    execute();
    bound_ = true;
  }

  if (has_result()) {
    // Query returns results, so cache column names and types
    cache_metadata();
    bindingOutput_.setup(pStatement_, types_);
  }
}

void MariaResultPrep::close() {
  if (has_result()) {
    mysql_free_result(pSpec_);
    pSpec_ = NULL;
  }

  if (pStatement_ != NULL) {
    mysql_stmt_close(pStatement_);
    pStatement_ = NULL;
  }

  pRes_->get_db_conn()->autocommit();
}

void MariaResultPrep::execute() {
  LOG_VERBOSE;

  complete_ = false;

  LOG_DEBUG << "mysql_stmt_execute()";
  if (mysql_stmt_execute(pStatement_) != 0)
    throw_error();
  if (!has_result() && !is_statement_) {
    // try again after mysql_stmt_execute, in case pSpec_ == NULL
    pSpec_ = mysql_stmt_result_metadata(pStatement_);
  }
  if (!has_result()) {
    rowsAffected_ += mysql_stmt_affected_rows(pStatement_);
  }
}

void MariaResultPrep::bind(const List& params) {
  rowsAffected_ = 0;

  bindingInput_.setup(pStatement_);
  bindingInput_.init_binding(params);

  if (has_result()) {
    complete_ = true;
  }
  else {
    while (bindingInput_.bind_next_row()) {
      execute();
    }
  }

  bound_ = true;
}

List MariaResultPrep::get_column_info() {
  CharacterVector names(nCols_), types(nCols_);
  for (int i = 0; i < nCols_; i++) {
    names[i] = names_[i];
    types[i] = type_name(types_[i]);
  }

  List out = List::create(names, types);
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -nCols_);
  out.attr("class") = "data.frame";
  out.attr("names") = CharacterVector::create("name", "type");

  return out;
}

bool MariaResultPrep::has_result() const {
  return pSpec_ != NULL;
}

bool MariaResultPrep::step() {
  LOG_VERBOSE;

  while (!fetch_row()) {
    LOG_VERBOSE;

    if (!bindingInput_.bind_next_row()) return false;
    execute();
  }

  rowsFetched_++;

  LOG_VERBOSE << rowsFetched_;
  return true;
}

bool MariaResultPrep::fetch_row() {
  LOG_VERBOSE;

  if (complete_) return false;

  LOG_VERBOSE << "mysql_stmt_fetch()";
  int result = mysql_stmt_fetch(pStatement_);

  LOG_VERBOSE << result;

  switch (result) {
  // We expect truncation whenever there's a string or blob
  case MYSQL_DATA_TRUNCATED:
  case 0:
    return true;
  case 1:
    throw_error();
  case MYSQL_NO_DATA:
    complete_ = true;
    return false;
  }
  return false;
}

List MariaResultPrep::fetch(int n_max) {
  if (!bound_)
    stop("Query needs to be bound before fetching");
  if (!has_result()) {
    if (names_.size() == 0) {
      warning("Use dbExecute() instead of dbGetQuery() for statements, and also avoid dbFetch()");
    }
    return df_create(types_, names_, 0);
  }

  int n = (n_max < 0) ? 100 : n_max;
  List out = df_create(types_, names_, n);
  if (n == 0)
    return out;

  int i = 0;

  for (;;) {
    if (i >= n && n_max > 0) break;

    if (!step())
      break;

    if (i >= n) {
      n *= 2;
      out = df_resize(out, n);
    }

    for (int j = 0; j < nCols_; ++j) {
      // Rcout << i << "," << j << "\n";
      bindingOutput_.set_list_value(out[j], i, j);
    }

    ++i;
    if (i % 1000 == 0)
      checkUserInterrupt();
  }

  // Trim back to what we actually used
  if (i < n) {
    out = df_resize(out, i);
  }
  // Set up S3 classes
  df_s3(out, types_);

  return out;
}

int MariaResultPrep::n_rows_affected() {
  if (!bound_) return NA_INTEGER;
  // FIXME: > 2^32 rows?
  return static_cast<int>(rowsAffected_);
}

int MariaResultPrep::n_rows_fetched() {
  if (!bound_) return 0;
  // FIXME: > 2^32 rows?
  return static_cast<int>(rowsFetched_);
}

bool MariaResultPrep::complete() {
  if (!bound_) return FALSE;
  return
    !has_result() || // query doesn't have results
    complete_;       // we've fetched all available results
}

void MariaResultPrep::throw_error() {
  stop(
    "%s [%i]",
    mysql_stmt_error(pStatement_),
    mysql_stmt_errno(pStatement_)
  );
}

void MariaResultPrep::cache_metadata() {
  LOG_VERBOSE;

  nCols_ = mysql_num_fields(pSpec_);
  MYSQL_FIELD* fields = mysql_fetch_fields(pSpec_);

  for (int i = 0; i < nCols_; ++i) {
    names_.push_back(fields[i].name);

    bool binary = fields[i].charsetnr == 63;
    MariaFieldType type = variable_type_from_field_type(fields[i].type, binary);
    types_.push_back(type);

    LOG_VERBOSE << i << " -> " << fields[i].name << "(" << fields[i].type << ", " << binary << ") => " << type_name(type);
  }
}
