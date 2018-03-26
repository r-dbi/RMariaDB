sql_data <- function(value, row.names = FALSE, warn = FALSE) {
  row.names <- compatRowNames(row.names)
  value <- sqlRownamesToColumn(value, row.names)

  value <- factor_to_string(value, warn = warn)
  value <- string_to_utf8(value)
  value <- posixlt_to_posixct(value)
  value <- numeric_to_finite(value)
  value
}

factor_to_string <- function(value, warn = FALSE) {
  is_factor <- vlapply(value, is.factor)
  if (warn && any(is_factor)) {
    warning("Factors converted to character", call. = FALSE)
  }
  value[is_factor] <- lapply(value[is_factor], as.character)
  value
}

quote_string <- function(value, conn) {
  is_character <- vlapply(value, is.character)
  value[is_character] <- lapply(value[is_character], dbQuoteString, conn = conn)
  value
}

string_to_utf8 <- function(value) {
  is_char <- vlapply(value, is.character)
  value[is_char] <- lapply(value[is_char], enc2utf8)
  value
}

posixlt_to_posixct <- function(value) {
  is_posixlt <- vlapply(value, inherits, "POSIXlt")
  value[is_posixlt] <- lapply(value[is_posixlt], as.POSIXct)
  value
}

numeric_to_finite <- function(value) {
  is_numeric <- vlapply(value, is.numeric) & !vlapply(value, is.integer)
  value[is_numeric] <- lapply(value[is_numeric], function(x) {
    x[!is.finite(x)] <- NA
    x
  })
  value
}
