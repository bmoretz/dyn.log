test_that("standard_levels_exist", {

  log_levels <- names(log_levels())

  expect_true(any(match(log_levels, 'trace')))
  expect_true(any(match(log_levels, 'debug')))
  expect_true(any(match(log_levels, 'info')))
  expect_true(any(match(log_levels, 'success')))
  expect_true(any(match(log_levels, 'warn')))
  expect_true(any(match(log_levels, 'error')))
  expect_true(any(match(log_levels, 'fatal')))
})

test_that("can_get_log_levels", {
  levels <- log_levels()

  expect_true(!is.null(levels))

  # base log levels
  expect_gte(length(levels), 7)
})

test_that("can_get_log_levels_generic", {
  levels <- log_levels()

  expect_true(!is.null(levels))

  # base log levels
  expect_gte(length(levels), 7)
})

test_that("can_get_log_levels", {
  levels <- log_levels()

  expect_true(!is.null(levels))

  # base log levels
  expect_gte(length(levels), 7)

  expect_true(!is.null(levels$fatal))
  expect_true(!is.null(levels$error))
  expect_true(!is.null(levels$warn))
  expect_true(!is.null(levels$succes))
  expect_true(!is.null(levels$info))
  expect_true(!is.null(levels$debug))
  expect_true(!is.null(levels$trace))
})

test_that("get_name_works", {
  level <- new_log_level("TEST", "test level", 10L)

  actual <- level_name(level)

  expect_equal(actual, "TEST")
})

test_that("cast_level_name_works", {
  level <- new_log_level("TEST", "test level", 10L)

  actual <- as.character(level)

  expect_equal(actual, "TEST")
})

test_that("get_severity_works", {
  level <- new_log_level("TEST", "test level", 10L)

  actual <- level_severity(level)

  expect_equal(actual, 10L)
})

test_that("cast_level_severity_works", {
  level <- new_log_level("TEST", "test level", 10L)

  actual <- as.integer(level)

  expect_equal(actual, 10L)
})

test_that("can_create_log_level", {

  level <- new_log_level("TEST", "test level", 10L)

  expect_true(!is.null(level))
  expect_equal(class(level), c('level_TEST', 'log_level'))
})

test_that("log_levels_display",{

  actual <- capture_output_lines({
    display_log_levels()
  })

  level <- log_levels("error")

  for(level in log_levels()) {
    info <- level_info(level)
    pattern <- paste(info$name, info$description)

    expect_true(any(!is.na(match(actual, pattern))))
  }
})
