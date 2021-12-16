test_that("can_create_layout", {

  new_log_layout(
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
    association = "test-layout"
  )

  layout <- log_layouts()[["test-layout"]]

  expect_true(!is.null(layout))
  expect_equal(class(layout), "log_layout")
  expect_equal(length(layout), 10)
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
