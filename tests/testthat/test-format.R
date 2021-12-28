test_that("literal_output_style", {

  literal <- new_fmt_literal(crayon::red$bold, "literal value")

  fmt_style <- style(literal)

  expect_true(!is.null(fmt_style))

  style_info <- unlist(attributes(fmt_style))

  expect_equal(style_info['class'], c(class = "crayon"))

  expect_equal(style_info['_styles.bold.open'], c(`_styles.bold.open` = '\033[1m'))
  expect_equal(style_info['_styles.bold.close'], c(`_styles.bold.close` = '\033[22m'))

  expect_equal(style_info['_styles.red.open'], c(`_styles.red.open` = '\033[31m'))
  expect_equal(style_info['_styles.red.palette'], c(`_styles.red.palette` = '2'))
  expect_equal(style_info['_styles.red.close'], c(`_styles.red.close` = '\033[39m'))

  value <- value(literal)

  expect_true(!is.null(value))
  expect_equal(value, "literal value")
})

test_that("metric_output", {

  context <- sys_context()
  metric <- new_fmt_metric(crayon::red$bold, "sysname")

  fmt_style <- style(metric)

  expect_true(!is.null(fmt_style))

  style_info <- unlist(attributes(fmt_style))

  expect_equal(style_info['class'], c(class = "crayon"))

  expect_equal(style_info['_styles.bold.open'], c(`_styles.bold.open` = '\033[1m'))
  expect_equal(style_info['_styles.bold.close'], c(`_styles.bold.close` = '\033[22m'))

  expect_equal(style_info['_styles.red.open'], c(`_styles.red.open` = '\033[31m'))
  expect_equal(style_info['_styles.red.palette'], c(`_styles.red.palette` = '2'))
  expect_equal(style_info['_styles.red.close'], c(`_styles.red.close` = '\033[39m'))

  actual <- value(metric, context)
  expected <- Sys.info()[['sysname']]
  expect_true(!is.null(actual))
  expect_equal(actual, expected)
})

test_that("newline_output", {
  newline <- new_fmt_line_break()

  expect_true(!is.null(newline))

  value <- value(newline)

  expect_equal(value, "\n")
})

test_that("timestamp_output_dflt_fmt", {

  ts <- new_fmt_timestamp(crayon::silver$italic)

  expect_true(!is.null(ts))

  fmt_style <- style(ts)

  expect_true(!is.null(fmt_style))
  expect_equal(class(fmt_style), "crayon")

  style_info <- unlist(attributes(fmt_style))

  expect_equal(style_info['class'], c(class = "crayon"))

  expect_equal(style_info['_styles.italic.open'], c(`_styles.italic.open` = '\033[3m'))
  expect_equal(style_info['_styles.italic.close'], c(`_styles.italic.close` = '\033[23m'))

  expect_equal(style_info['_styles.silver.open'], c(`_styles.silver.open` = '\033[90m'))
  expect_equal(style_info['_styles.silver.palette'], c(`_styles.silver.palette` = '9'))
  expect_equal(style_info['_styles.silver.close'], c(`_styles.silver.close` = '\033[39m'))

  actual_time <- format(Sys.time(), format = "[%x %H:%M:%S %z]")
  evaluated_time <- attr(ts, 'value')(format(ts))

  expect_equal(actual_time, evaluated_time)

  actual_value <- value(ts)
  expected_value <- format(Sys.time(), "[%x %H:%M:%S %z]")

  expect_equal(actual_value, expected_value)
})

test_that("timestamp_output_custom_fmt", {

  cust_format <- "[%Y-%m-%d %H:%M:%S]"

  ts <- new_fmt_timestamp(crayon::silver$italic, cust_format)

  fmt_style <- style(ts)

  expect_true(!is.null(ts))

  fmt_style <- style(ts)

  expect_true(!is.null(fmt_style))
  expect_equal(class(fmt_style), "crayon")

  style_info <- unlist(attributes(fmt_style))

  expect_equal(style_info['class'], c(class = "crayon"))

  expect_equal(style_info['_styles.italic.open'], c(`_styles.italic.open` = '\033[3m'))
  expect_equal(style_info['_styles.italic.close'], c(`_styles.italic.close` = '\033[23m'))

  expect_equal(style_info['_styles.silver.open'], c(`_styles.silver.open` = '\033[90m'))
  expect_equal(style_info['_styles.silver.palette'], c(`_styles.silver.palette` = '9'))
  expect_equal(style_info['_styles.silver.close'], c(`_styles.silver.close` = '\033[39m'))

  actual_format <- format(ts)
  expect_equal(actual_format, cust_format)

  actual_time <- format(Sys.time(), cust_format)
  evaluated_time <- attr(ts, 'value')(format(ts))

  expect_equal(actual_time, evaluated_time)

  actual_value <- value(ts)
  expected_value <- format(Sys.time(), cust_format)

  expect_equal(actual_value, expected_value)
})

test_that("cls_attribute_custom_fmt", {

  obj <- TestObject$new()

  cls_fld <- new_fmt_cls_field(crayon::cyan$bold, "id")

  # test formatting

  expect_true(!is.null(cls_fld))

  fmt_style <- style(cls_fld)

  expect_true(!is.null(fmt_style))
  expect_equal(class(fmt_style), "crayon")

  style_info <- unlist(attributes(fmt_style))

  expect_equal(style_info['class'], c(class = "crayon"))

  expect_equal(style_info['_styles.bold.open'], c(`_styles.bold.open` = '\033[1m'))
  expect_equal(style_info['_styles.bold.close'], c(`_styles.bold.close` = '\033[22m'))

  expect_equal(style_info['_styles.cyan.open'], c(`_styles.cyan.open` = '\033[36m'))
  expect_equal(style_info['_styles.cyan.palette'], c(`_styles.cyan.palette` = '7'))
  expect_equal(style_info['_styles.cyan.close'], c(`_styles.cyan.close` = '\033[39m'))

  # test format evaluation

  scope <- class_scope(obj)

  actual <- value(cls_fld, scope)

  expect_equal(actual, obj$id)
})
