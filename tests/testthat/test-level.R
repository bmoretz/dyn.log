test_that("standard_levels_exist", {

  log_levels <- log_levels()

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

  expect_true(!is.null(log_levels("fatal")))
  expect_true(!is.null(log_levels("error")))
  expect_true(!is.null(log_levels("warn")))
  expect_true(!is.null(log_levels("success")))
  expect_true(!is.null(log_levels("info")))
  expect_true(!is.null(log_levels("debug")))
  expect_true(!is.null(log_levels("debug")))
})

test_that("get_name_works", {
  level <- new_log_level("TEST", "test level", 10L)

  actual <- level_name(level)

  expect_equal(actual, "TEST")

  # clean-up test level
  log_levels("test", level = NA)

  all_levels <- log_levels()
  expect_true(all(is.na(match(all_levels, "test"))))
})

test_that("cast_level_name_works", {
  level <- new_log_level("TEST", "test level", 10L)

  actual <- as.character(level)

  expect_equal(actual, "TEST")

  # clean-up test level
  log_levels("test", level = NA)

  all_levels <- log_levels()
  expect_true(all(is.na(match(all_levels, "test"))))
})

test_that("get_severity_works", {
  level <- new_log_level("TEST", "test level", 10L)

  actual <- level_severity(level)

  expect_equal(actual, 10L)

  # clean-up test level
  log_levels("test", level = NA)

  all_levels <- log_levels()
  expect_true(all(is.na(match(all_levels, "test"))))
})

test_that("cast_level_severity_works", {
  level <- new_log_level(
    "TEST",
    "test level",
    10L
  )

  actual <- as.integer(level)

  expect_equal(actual, 10L)

  # clean-up test level
  log_levels("test", level = NA)

  all_levels <- log_levels()
  expect_true(all(is.na(match(all_levels, "test"))))
})

test_that("can_create_log_level", {

  level <- new_log_level("TEST", "test level", 10L)

  expect_true(!is.null(level))
  expect_equal(class(level), c('level_TEST', 'log_level'))

  # clean-up test level
  log_levels("test", level = NA)
})

test_that("log_levels_display",{

  actual <- capture_output_lines({
    display_log_levels()
  })

  for(level in log_levels()) {
    info <- level_info(level)
    pattern <- paste(info$name, info$description)

    expect_true(any(!is.na(match(actual, pattern))), label = info$name)
  }
})

test_that("can_remove_log_level", {

  lvl <- new_log_level(name = "TEST",
                       description = "for testing",
                       severity = 42L,
                       log_style = crayon::blue,
                       msg_style = crayon::silver)

  all_levels <- log_levels()

  expect_true(any(!is.na(match(all_levels, tolower(level_name(lvl))))))

  log_levels("TEST", level = NA)

  all_levels <- log_levels()
  expect_true(all(is.na(match(all_levels, tolower(level_name(lvl))))))
})

test_that("can_get_log_level_by_name", {
  level_names <- log_levels()

  matches <- sapply(level_names, function(lvl_name) {
    lvl <- log_levels(lvl_name)
    any(match(class(lvl), 'log_level'))
  })

  expect_true(all(matches))
})

test_that("can_get_lvl_info_by_name",{

  lvl_info <- lapply(log_levels(), function(lvl_name) {
    lvl <- log_levels(lvl_name)
    info <- level_info(lvl)
  })

  expect_true(all(!is.null(lvl_info)))
})

test_that("invalid_log_level_detail_stops", {
  expect_error({
    level_info("ffdsa134")
  })
})
