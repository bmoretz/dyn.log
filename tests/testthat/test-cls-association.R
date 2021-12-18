test_that("can_associate_log_layout", {

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
    new_fmt_literal(crayon::bgCyan$bold, "Object Id:"),
    new_fmt_cls_field(crayon::cyan$bold, "id"),
    association = "TestObject"
  )

  expect_true(!is.null(get_log_layout("TestObject")))

  test_obj <- TestObject$new()
  test_obj$test_method()

  Logger$debug("testing")
})

