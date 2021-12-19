create_default_layout <- function() {
  new_log_layout(
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_log_msg(),
    association = "default"
  )
}

local_init <- function(pos=1) {
  assign('Logger', Logger, envir = as.environment(pos))
}
