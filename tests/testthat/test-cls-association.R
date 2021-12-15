test_that("can_add_log_level", {

  new_log_layout(
    new_fmt_cls_field(crayon::cyan$bold, "id"),
    new_fmt_metric(crayon::green$bold, "sysname"),
    new_fmt_metric(crayon::yellow$bold, "release"),
    new_fmt_line_break(),
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_metric(crayon::magenta$bold, "top_call"),
    new_fmt_literal(crayon::blue$italic, "literal text"),
    new_fmt_log_msg(),
    new_fmt_line_break(),
    new_fmt_metric(crayon::cyan$bold, "call_stack"),
    association = "TestObject"
  )

  layout <- get_layout("TestObject")

  evaluated <- value(layout)

  obj <- TestObject$new()
  obj$test_method()

  Logger$debug("testing")

})
