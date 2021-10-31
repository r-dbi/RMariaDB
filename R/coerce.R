sql_data <- function(value, conn, row.names = FALSE, warn = FALSE) {
  row.names <- compatRowNames(row.names)
  value <- sqlRownamesToColumn(value, row.names)

  value <- factor_to_string(value, warn = warn)
  value <- string_to_utf8(value)
  value <- difftime_to_hms(value)
  value <- posixlt_to_posixct(value, conn@timezone)
  value <- numeric_to_finite(value)
  value <- date_to_double(value)
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

difftime_to_hms <- function(value) {
  is_difftime <- vlapply(value, inherits, "difftime")
  # https://github.com/tidyverse/hms/issues/84
  value[is_difftime] <- lapply(value[is_difftime], function(x) {
    mode(x) <- "double"
    hms::as_hms(x)
  })
  value
}

posixlt_to_posixct <- function(value, timezone) {
  is_posixlt <- vlapply(value, inherits, "POSIXt")
  value[is_posixlt] <- lapply(value[is_posixlt], function(x) {
    x <- as.POSIXct(x)

    # The database expects times as local time
    if (timezone != "UTC") {
      x <- lubridate::with_tz(x, timezone)
      x <- lubridate::force_tz(x, "UTC")
    }

    x
  })
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

date_to_double <- function(value) {
  is_date <- vlapply(value, inherits, "Date")
  value[is_date] <- lapply(value[is_date], function(x) {
    mode(x) <- "double"
    x
  })
  value
}
