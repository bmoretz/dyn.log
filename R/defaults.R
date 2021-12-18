create_default_layouts <- function() {

  new_log_layout(
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_log_msg(),
    association = "default"
  )
}
