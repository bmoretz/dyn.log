test_that("standard_levels_exist", {

  expect_true(!is.null(FATAL))
  expect_true(!is.null(ERROR))
  expect_true(!is.null(WARN))
  expect_true(!is.null(SUCCESS))
  expect_true(!is.null(INFO))
  expect_true(!is.null(DEBUG))
  expect_true(!is.null(TRACE))
})

test_that("can_get_log_levels", {
  levels <- log_levels()

  expect_true(!is.null(levels))

  # base log levels
  expect_equal(length(levels), 7)
})

test_that("can_get_log_levels_generic", {
  levels <- log_levels()

  expect_true(!is.null(levels))

  # base log levels
  expect_equal(length(levels), 7)
})

test_that("can_get_log_levels", {
  levels <- log_levels()

  expect_true(!is.null(levels))

  # base log levels
  expect_equal(length(levels), 7)

  expect_true(!is.null(levels$FATAL))
  expect_true(!is.null(levels$ERROR))
  expect_true(!is.null(levels$WARN))
  expect_true(!is.null(levels$SUCCESS))
  expect_true(!is.null(levels$INFO))
  expect_true(!is.null(levels$DEBUG))
  expect_true(!is.null(levels$TRACE))
})

test_that("get_name_works", {
  level <- new_log_level("TEST", 10L)

  actual <- level_name(level)

  expect_equal(actual, "TEST")
})

test_that("cast_level_name_works", {
  level <- new_log_level("TEST", 10L)

  actual <- as.character(level)

  expect_equal(actual, "TEST")
})

test_that("get_severity_works", {
  level <- new_log_level("TEST", 10L)

  actual <- level_severity(level)

  expect_equal(actual, 10L)
})

test_that("cast_level_severity_works", {
  level <- new_log_level("TEST", 10L)

  actual <- as.integer(level)

  expect_equal(actual, 10L)
})

test_that("can_create_log_level", {

  level <- new_log_level("TEST", 10L)

  expect_true(!is.null(level))
  expect_equal(class(level), c('TEST', 'log_level'))
})
