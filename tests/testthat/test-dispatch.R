test_that("log_single_instance", {

  inst_n <- LogDispatch$new()
  inst_m <- LogDispatch$new()

  expect_true(identical(inst_n, inst_m))
})

test_that("has_system_metrics", {

  log <- LogDispatchTester$new()
  context <- log$get_system_context()

  expect_named(context['sysname'])
  expect_gt(nchar(context['sysname']), 0)

  expect_named(context['release'])
  expect_gt(nchar(context['release']), 0)

  expect_named(context['version'])
  expect_gt(nchar(context['version']), 0)

  expect_named(context['nodename'])
  expect_gt(nchar(context['nodename']), 0)

  expect_named(context['machine'])
  expect_gt(nchar(context['machine']), 0)

  expect_named(context['login'])
  expect_gt(nchar(context['login']), 0)

  expect_named(context['user'])
  expect_gt(nchar(context['user']), 0)

  expect_named(context['r-ver'])
  expect_gt(nchar(context['r-ver']), 0)
})

test_that("default_log_dispatch_works", {
  log <- LogDispatchTester$new()
  log$get_settings()

  log$trace("test")
})

test_that("can_add_log_level", {

  logger <- LogDispatch$new()

  test_level <- new_log_level("TEST", 100L,
                              log_style = crayon::bgGreen$italic,
                              msg_style = crayon::cyan$bold)

  expect_true(!is.null(test_level))

  actual <- capture_output({
    logger$add_log_level(test_level)$test("msg")
  })

  expect_equal(actual, "")
})

test_that("get_context_works", {
  log_layout <- new_log_layout(
    new_fmt_metric(crayon::green$bold, "sysname"),
    new_fmt_line_break(),
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_metric(crayon::magenta$bold, "top_call"),
    new_fmt_literal(crayon::blue$italic, "literal text"),
    new_fmt_log_msg(),
    new_fmt_line_break(),
    new_fmt_metric(crayon::cyan$bold, "call_stack")
  )

})
