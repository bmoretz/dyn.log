test_that("literal_output_style", {

  literal <- new_fmt_literal(crayon::red$bold, "literal value")

  fmt_style <- style(literal)

  expect_true(!is.null(fmt_style))

  style_info <- unlist(attributes(fmt_style))

  expect_equal(style_info['class'], c(class = "crayon"))

  expect_equal(style_info['_styles.bold.open'], c(`_styles.bold.open` = '\033[1m'))
  expect_equal(style_info['_styles.bold.close'], c(`_styles.bold.close` = '\033[22m'))
  expect_equal(style_info['_styles.red.open'], c(`_styles.red.open` = '\033[31m'))
  expect_equal(style_info['_styles.bold.open'], c(`_styles.bold.open` = '\033[1m'))
  expect_equal(style_info['_styles.red.palette'], c(`_styles.red.palette` = '2'))

  value <- value(literal)

  expect_true(!is.null(value))
  expect_equal(value, "literal value")
})

test_that("metric_output", {

  metric <- new_fmt_metric(crayon::red$bold, "sysname")

  fmt_style <- style(metric)

  expect_true(!is.null(fmt_style))

  style_info <- unlist(attributes(fmt_style))

  expect_equal(style_info['class'], c(class = "crayon"))

  expect_equal(style_info['_styles.bold.open'], c(`_styles.bold.open` = '\033[1m'))
  expect_equal(style_info['_styles.bold.close'], c(`_styles.bold.close` = '\033[22m'))
  expect_equal(style_info['_styles.bold.open'], c(`_styles.bold.open` = '\033[1m'))

  expect_equal(style_info['_styles.red.palette'], c(`_styles.red.palette` = '2'))
  expect_equal(style_info['_styles.red.open'], c(`_styles.red.open` = '\033[31m'))

  value <- value(metric)

  expect_true(!is.null(value))
  expect_equal(value, "{sysname}")
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
  expect_equal(style_info['_styles.italic.open'], c(`_styles.italic.open` = '\033[3m'))

  expect_equal(style_info['_styles.silver.open'], c(`_styles.silver.open` = '\033[90m'))
  expect_equal(style_info['_styles.silver.palette'], c(`_styles.silver.palette` = '9'))

  actual_time <- format(Sys.time(), format = "%x %H:%M:%S %z")
  evaluated_time <- attr(ts, 'value')(format(ts))

  expect_equal(actual_time, evaluated_time)

  actual_value <- value(ts)
  expected_value <- format(Sys.time(), "%x %H:%M:%S %z")

  expect_equal(actual_value, expected_value)
})

test_that("timestamp_output_custom_fmt", {

  cust_format <- "%Y-%m-%d %H:%M:%S"

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
  expect_equal(style_info['_styles.italic.open'], c(`_styles.italic.open` = '\033[3m'))

  expect_equal(style_info['_styles.silver.open'], c(`_styles.silver.open` = '\033[90m'))
  expect_equal(style_info['_styles.silver.palette'], c(`_styles.silver.palette` = '9'))

  actual_format <- format(ts)
  expect_equal(actual_format, cust_format)

  actual_time <- format(Sys.time(), cust_format)
  evaluated_time <- attr(ts, 'value')(format(ts))

  expect_equal(actual_time, evaluated_time)

  actual_value <- value(ts)
  expected_value <- format(Sys.time(), cust_format)

  expect_equal(actual_value, expected_value)
})

test_that("call_stack_output", {

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          get_call_stack()
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  call_stack <- test(1,2,3)

  level_one <- deparse(call_stack[[1]])
  expect_equal(level_one, 'inner(d, e, f)')

  level_two <- deparse(call_stack[[2]])
  expect_equal(level_two, 'outer(x, y, z)')

  level_three <- deparse(call_stack[[3]])
  expect_equal(level_three, 'wrapper(a, b, c)')

  level_four <- deparse(call_stack[[4]])
  expect_equal(level_four, 'test(1, 2, 3)')
})

test_that("func_call_outputs_no_args", {

  # get 3rd level of the call stack
  fmt_fn <- new_fmt_func_call(crayon::magenta$bold, 3)

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          value(fmt_fn)
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  actual <- test()
  expected <- 'inner'

  expect_equal(actual, expected)
})

test_that("func_call_outputs_with_args", {

  # get 3rd level of the call stack
  fmt_fn <- new_fmt_func_call(crayon::magenta$bold, 3, keep_args = T)

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          value(fmt_fn)
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  actual <- test()
  expected <- 'inner(d, e, f)'

  expect_equal(actual, expected)
})

test_that("call_stack_outputs_with_args", {

  # get 3rd level of the call stack
  fmt_callstack <- new_fmt_call_stack(crayon::magenta$bold, 3, keep_args = T)

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          value(fmt_callstack)
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  actual <- test()

  expected <- 'inner(d, e, f) outer(x, y, z) wrapper(a, b, c) test()'

  #expect_equal(actual, expected)
})

test_that("call_stack_outputs_no_args", {

  # get 3rd level of the call stack
  fmt_callstack <- new_fmt_call_stack(crayon::magenta$bold, 3)

  test <- function(a, b, c) {
    wrapper <- function(x, y, z) {
      outer <- function(d, e, f) {
        inner <- function(g, h, i) {
          value(fmt_callstack)
        }

        inner(d, e, f)
      }

      outer(x, y, z)
    }
    wrapper(a, b, c)
  }

  actual <- test()

  expected <- 'inner outer wrapper test'

  # expect_equal(actual, expected)
})

test_that("log_output_format", {

  fmt_sysname <- new_fmt_metric(crayon::green$bold, "sysname")
  fmt_release <- new_fmt_metric(crayon::red$bold, "release")

  fmt_text1 <- new_fmt_literal(crayon::blue$italic, "literal text1")

  layout <- new_log_layout(fmt_sysname,
                           fmt_release,
                           new_fmt_line_break(),
                           fmt_text1)

  expect_equal(length(layout), 4)

  actual <- capture_output_lines({
    cat(value(layout))
  })

  expected <- c("{sysname} {release}",
                "literal text1" )

  expect_equal(actual, expected)
})

test_that("loading_log_config_works", {

  log_config_file <- system.file("test-data",
                                 "test-layout.yml",
                                 package = "dyn.log")

  config <- load_log_configuration(log_config_file)

  expect_equal(config$settings$threshold, "TRACE")

  with(config, {
    expect_true(!is.null(levels$TRACE))
    expect_true(!is.null(levels$DEBUG))
    expect_true(!is.null(levels$INFO))
    expect_true(!is.null(levels$SUCCESS))
    expect_true(!is.null(levels$WARN))
    expect_true(!is.null(levels$ERROR))
    expect_true(!is.null(levels$FATAL))
  })
})

test_that("multi_line_fmt_works_1", {

  fmt_sysname <- new_fmt_metric(crayon::red$bold, "sysname")
  fmt_release <- new_fmt_metric(crayon::green$bold, "release")
  fmt_version <- new_fmt_metric(crayon::blue$bold, "version")

  layout <- new_log_layout(fmt_sysname,
                           fmt_release,
                           fmt_version,
                           new_fmt_line_break())

  actual <- capture_output_lines({
    cat(value(layout))
  })

  expected <- "{sysname} {release} {version}"

  expect_equal(actual, expected)
})

test_that("multi_line_fmt_works_2", {

  fmt_sysname <- new_fmt_metric(crayon::red$bold, "sysname")
  fmt_release <- new_fmt_metric(crayon::green$bold, "release")
  fmt_version <- new_fmt_metric(crayon::blue$bold, "version")

  fmt_text1 <- new_fmt_literal(crayon::red$italic, "literal1")
  fmt_text2 <- new_fmt_literal(crayon::green$italic, "literal2")
  fmt_text3 <- new_fmt_literal(crayon::blue$italic, "literal3")

  layout <- new_log_layout(fmt_sysname,
                           fmt_release,
                           fmt_version,
                           new_fmt_line_break(),
                           fmt_text1,
                           fmt_text2,
                           fmt_text3,
                           sep = '-')

  actual <- capture_output_lines({
    cat(value(layout))
  })

  expected <- c("{sysname}-{release}-{version}",
                "literal1-literal2-literal3")

  expect_equal(actual, expected)
})

test_that("multi_line_fmt_works_3", {

  fmt_sysname <- new_fmt_metric(crayon::red$bold, "sysname")
  fmt_release <- new_fmt_metric(crayon::green$bold, "release")
  fmt_version <- new_fmt_metric(crayon::blue$bold, "version")

  fmt_text1 <- new_fmt_literal(crayon::red$italic, "literal1")
  fmt_text2 <- new_fmt_literal(crayon::green$italic, "literal2")
  fmt_text3 <- new_fmt_literal(crayon::blue$italic, "literal3")

  fmt_machine <- new_fmt_metric(crayon::red$bold, "machine")
  fmt_nodename <- new_fmt_metric(crayon::green$bold, "nodename")
  fmt_user <- new_fmt_metric(crayon::blue$bold, "user")

  layout <- new_log_layout(fmt_sysname,
                           fmt_release,
                           fmt_version,
                           new_fmt_line_break(),
                           fmt_text1,
                           fmt_text2,
                           fmt_text3,
                           new_fmt_line_break(),
                           fmt_machine,
                           fmt_nodename,
                           fmt_user,
                           sep = '---')

  actual <- capture_output_lines({
    cat(value(layout))
  })

  expected <- c("{sysname}---{release}---{version}",
                "literal1---literal2---literal3",
                "{machine}---{nodename}---{user}")

  expect_equal(actual, expected)
})

test_that("multi_line_fmt_works_4", {

  fmt_sysname <- new_fmt_metric(crayon::red$bold, "sysname")
  fmt_release <- new_fmt_metric(crayon::green$bold, "release")
  fmt_version <- new_fmt_metric(crayon::blue$bold, "version")

  fmt_text1 <- new_fmt_literal(crayon::red$italic, "literal1")
  fmt_text2 <- new_fmt_literal(crayon::green$italic, "literal2")
  fmt_text3 <- new_fmt_literal(crayon::blue$italic, "literal3")

  fmt_machine <- new_fmt_metric(crayon::red$bold, "machine")
  fmt_nodename <- new_fmt_metric(crayon::green$bold, "nodename")
  fmt_user <- new_fmt_metric(crayon::blue$bold, "user")

  fmt_text4 <- new_fmt_literal(crayon::red$italic, "literal4")
  fmt_text5 <- new_fmt_literal(crayon::green$italic, "literal5")
  fmt_text6 <- new_fmt_literal(crayon::blue$italic, "literal6")

  layout <- new_log_layout(fmt_sysname,
                           fmt_release,
                           fmt_version,
                           new_fmt_line_break(),
                           fmt_text1,
                           fmt_text2,
                           fmt_text3,
                           new_fmt_line_break(),
                           fmt_machine,
                           fmt_nodename,
                           fmt_user,
                           new_fmt_line_break(),
                           fmt_text4,
                           fmt_text5,
                           fmt_text6,
                           sep = '---')

  actual <- capture_output_lines({
    cat(value(layout))
  })

  expected <- c("{sysname}---{release}---{version}",
                "literal1---literal2---literal3",
                "{machine}---{nodename}---{user}",
                "literal4---literal5---literal6")

  expect_equal(actual, expected)
})

test_that("basic_case",{

  func <- ".inner(d, e, f)"
  actual <- extract_func_name(func)

  expect_equal(actual, ".inner")
})

test_that("obj_init",{

  func <- "Test$new(d, e, f)"
  actual <- extract_func_name(func)

  expect_equal(actual, "Test$new")
})
