test_that("can_create_layout", {

  log_layout <- new_log_layout(
    new_fmt_metric(crayon::green$bold, "sysname"),
    new_fmt_metric(crayon::yellow$bold, "release"),
    new_fmt_line_break(),
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_metric(crayon::magenta$bold, "top_call"),
    new_fmt_literal(crayon::blue$italic, "literal text"),
    new_fmt_log_msg(),
    new_fmt_line_break(),
    new_fmt_metric(crayon::cyan$bold, "call_stack")
  )

  expect_true(!is.null(log_layout))
  expect_equal(class(log_layout), "log_layout")
  expect_equal(length(log_layout), 10)
})

test_that("log_layout_format", {

  log_layout <- new_log_layout(
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
    association = "test-layout-format"
  )

  expect_true(!is.null(log_layout))
  expect_equal(class(log_layout), "log_layout")

  fmt <- format(log_layout)

  expect_true(!is.null(fmt))
  expect_equal(class(fmt), "list")
  expect_equal(length(fmt), 10)
})

test_that("log_layout_format_types", {

  log_layout <- new_log_layout(
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
    association = "test-layout-format"
  )


  actual <- get_format_types(log_layout)

  expect_gt(which(!is.na(match(actual, 'fmt_metric'))), 0)
  expect_gt(which(!is.na(match(actual, 'fmt_layout'))), 0)
  expect_gt(which(!is.na(match(actual, 'fmt_newline'))), 0)
  expect_gt(which(!is.na(match(actual, 'fmt_level_info'))), 0)
  expect_gt(which(!is.na(match(actual, 'fmt_timestamp'))), 0)
  expect_gt(which(!is.na(match(actual, 'fmt_literal'))), 0)
  expect_gt(which(!is.na(match(actual, 'new_fmt_log_msg'))), 0)
})

test_that("log_layout_evaluates_simple_singleline", {

  log_layout <- new_log_layout(
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_log_msg()
  )

  expect_true(!is.null(log_layout))

  actual <- evaluate_layout(log_layout, context = list())

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed("level_info(level)")))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(" {format(level, msg = {log_msg})}")))
})

test_that("log_layout_evaluates_simple_multiline", {

  log_layout <- new_log_layout(
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_line_break(),
    new_fmt_log_msg()
  )

  expect_true(!is.null(log_layout))

  actual <- evaluate_layout(log_layout, context = list())

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed("level_info(level)")))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed("\n{format(level, msg = {log_msg})}")))
})

test_that("log_layout_evaluates_metrics_singleline", {

  log_layout <- new_log_layout(
    new_fmt_log_level(),
    new_fmt_metric(crayon::green$bold, "sysname"),
    new_fmt_metric(crayon::red$bold, "release"),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_log_msg()
  )

  expect_true(!is.null(log_layout))

  actual <- evaluate_layout(log_layout, context = list(fmt_metric = sys_context()))

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed("level_info(level)")))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(" {format(level, msg = {log_msg})}")))

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(Sys.info()[["sysname"]])))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(Sys.info()[["release"]])))
})

test_that("log_layout_evaluates_metrics_multiline", {

  log_layout <- new_log_layout(
    new_fmt_metric(crayon::green$bold, "sysname"),
    new_fmt_metric(crayon::red$bold, "release"),
    new_fmt_line_break(),
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_log_msg()
  )

  expect_true(!is.null(log_layout))

  actual <- evaluate_layout(log_layout, context = list(fmt_metric = sys_context()))

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed("\n{level_info(level)}")))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(" {format(level, msg = {log_msg})}")))

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(Sys.info()[["sysname"]])))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(Sys.info()[["release"]])))
})

test_that("log_layout_evaluates_cls_attributes_multiline", {

  test_obj <- TestObject$new()

  log_layout <- new_log_layout(
    new_fmt_metric(crayon::green$bold, "sysname"),
    new_fmt_metric(crayon::red$bold, "release"),
    new_fmt_line_break(),
    new_fmt_log_level(),
    new_fmt_timestamp(crayon::silver$italic),
    new_fmt_log_msg(),
    new_fmt_line_break(),
    new_fmt_literal(crayon::bgCyan$bold, "Object Id:"),
    new_fmt_cls_field(crayon::cyan$bold, "id")
  )

  fmt_types <- get_format_types(log_layout)

  context <- list()

  lapply(fmt_types, function(fmt_type) {
    switch(fmt_type,
           'fmt_metric' = {

            },
           'fmt_cls_field' = {

           }
    )
    invisible()
  })

  expect_true(!is.null(log_layout))

  cls_scope <- LogDispatch$new()$private$get_class_scope(test_obj)

  context <- list(fmt_metric = sys_context(),
                  fmt_cls_field = cls_scope)

  actual <- evaluate_layout(log_layout, context)

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed("\n{level_info(level)}")))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(" {format(level, msg = {log_msg})}")))

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(Sys.info()[["sysname"]])))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(Sys.info()[["release"]])))

  expect_true(stringr::str_detect(actual, pattern = stringr::fixed("Object Id:")))
  expect_true(stringr::str_detect(actual, pattern = stringr::fixed(test_obj$id)))
})

test_that("multi_line_fmt_works_2", {

  fmt_sysname <- new_fmt_metric(crayon::red$bold, "sysname")
  fmt_release <- new_fmt_metric(crayon::green$bold, "release")
  fmt_version <- new_fmt_metric(crayon::blue$bold, "version")

  fmt_text1 <- new_fmt_literal(crayon::red$italic, "literal1")
  fmt_text2 <- new_fmt_literal(crayon::green$italic, "literal2")
  fmt_text3 <- new_fmt_literal(crayon::blue$italic, "literal3")

  log_layout <- new_log_layout(
    new_fmt_metric(crayon::red$bold, "sysname"),
    new_fmt_metric(crayon::green$bold, "release"),
    new_fmt_metric(crayon::blue$bold, "version"),
    new_fmt_line_break(),
    new_fmt_literal(crayon::red$italic, "literal1"),
    new_fmt_literal(crayon::green$italic, "literal2"),
    new_fmt_literal(crayon::blue$italic, "literal3"),
    sep = '-')

  context <- list(fmt_metric = sys_context())
  actual <- evaluate_layout(log_layout, context)

  expected_metrics <- paste(Sys.info()[["sysname"]],
                            Sys.info()[["release"]],
                            Sys.info()[["version"]],
                            sep = '-')

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_metrics)))

  expected_literals <- paste("literal1",
                             "literal2",
                             "literal3",
                             sep = "-")

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_literals)))

  output <- capture_output_lines({
    cat(actual)
  })

  expect_equal(length(output), 2)
})

test_that("multi_line_fmt_works_3", {

  log_layout <- new_log_layout(
    new_fmt_metric(crayon::red$bold, "sysname"),
    new_fmt_metric(crayon::green$bold, "release"),
    new_fmt_metric(crayon::blue$bold, "version"),
    new_fmt_line_break(),
    new_fmt_literal(crayon::red$italic, "literal1"),
    new_fmt_literal(crayon::green$italic, "literal2"),
    new_fmt_literal(crayon::blue$italic, "literal3"),
    new_fmt_line_break(),
    new_fmt_metric(crayon::red$bold, "machine"),
    new_fmt_metric(crayon::green$bold, "nodename"),
    new_fmt_metric(crayon::blue$bold, "user"),
    sep = '---')

  context <- list(fmt_metric = sys_context())
  actual <- evaluate_layout(log_layout, context)

  expected_metrics <- paste(Sys.info()[["sysname"]],
                            Sys.info()[["release"]],
                            Sys.info()[["version"]],
                            sep = '---')

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_metrics)))

  expected_literals <- paste("literal1",
                             "literal2",
                             "literal3",
                             sep = "---")

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_literals)))

  expected_metrics_2 <- paste(Sys.info()[["machine"]],
                            Sys.info()[["nodename"]],
                            Sys.info()[["user"]],
                            sep = '---')

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_metrics_2)))

  output <- capture_output_lines({
    cat(actual)
  })

  expect_equal(length(output), 3)
})

test_that("multi_line_fmt_works_4", {

  log_layout <- new_log_layout(
     new_fmt_metric(crayon::red$bold, "sysname"),
     new_fmt_metric(crayon::green$bold, "release"),
     new_fmt_metric(crayon::blue$bold, "version"),
     new_fmt_line_break(),
     new_fmt_literal(crayon::red$italic, "literal1"),
     new_fmt_literal(crayon::green$italic, "literal2"),
     new_fmt_literal(crayon::blue$italic, "literal3"),
     new_fmt_line_break(),
     new_fmt_metric(crayon::red$bold, "machine"),
     new_fmt_metric(crayon::green$bold, "nodename"),
     new_fmt_metric(crayon::blue$bold, "user"),
     new_fmt_line_break(),
     new_fmt_literal(crayon::red$italic, "literal4"),
     new_fmt_literal(crayon::green$italic, "literal5"),
     new_fmt_literal(crayon::blue$italic, "literal6"),
     sep = '---')

  context <- list(fmt_metric = sys_context())
  actual <- evaluate_layout(log_layout, context)

  expected_metrics <- paste(Sys.info()[["sysname"]],
                            Sys.info()[["release"]],
                            Sys.info()[["version"]],
                            sep = '---')

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_metrics)))

  expected_literals <- paste("literal1",
                             "literal2",
                             "literal3",
                             sep = "---")

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_literals)))

  expected_metrics_2 <- paste(Sys.info()[["machine"]],
                              Sys.info()[["nodename"]],
                              Sys.info()[["user"]],
                              sep = '---')

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_metrics_2)))

  expected_literals_2 <- paste("literal4",
                             "literal5",
                             "literal6",
                             sep = "---")

  expect_true(stringr::str_detect(actual, stringr::fixed(expected_literals_2)))

  output <- capture_output_lines({
    cat(actual)
  })

  expect_equal(length(output), 4)
})
