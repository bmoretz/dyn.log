test_that("log_single_instance", {

  inst_n <- LogDispatch$new()
  inst_m <- LogDispatch$new()

  expect_true(identical(inst_n, inst_m))
})

test_that("default_log_dispatch_works", {
  log <- LogDispatch$new()

  output <- capture_output_lines({
    log$trace("test")
  })

  expect_gt(length(output), 0)
  expect_gt(nchar(output), 0)
})

test_that("log_threshold_works", {

  logger <- LogDispatch$new()

  logger$private$settings$threshold <- "INFO"

  actual <- capture_output({
    var1 <- "abc"; var2 <- 123; var3 <- 0.7535651
    logger$trace("log msg local vars: {var1}, {var2}, {var3}")
  })

  logger$private$settings$threshold <- "TRACE"

  expect_equal(actual, "")
  expect_false(stringr::str_detect(actual, stringr::fixed("TEST ")))
  expect_false(stringr::str_detect(actual, stringr::fixed("log msg local vars: abc, 123, 0.7535651")))
})

test_that("can_set_log_settings", {

  test_config_file <- system.file("test-data",
                                  "test-config.yml",
                                  package = "dyn.log")

  log_config <- yaml::read_yaml(test_config_file, eval.expr = T)

  dispatch <- LogDispatchTester$new()
  dispatch$set_settings(log_config$settings)

  actual <- dispatch$get_settings()

  expect_equal(actual, log_config$settings)
})

test_that("add_log_level_works", {

  test_config_file <- system.file("test-data",
                                  "test-config.yml",
                                  package = "dyn.log")

  log_config <- yaml::read_yaml(test_config_file, eval.expr = T)

  dispatch <- LogDispatchTester$new()
  dispatch$set_settings(log_config$settings)

  lvl <- new_log_level(name = "TEST",
                       description = "for testing",
                       severity = 42L,
                       log_style = crayon::blue,
                       msg_style = crayon::silver)

  dispatch$add_log_level(lvl)

  actual <- capture_output({
    var1 <- "abc"; var2 <- 123; var3 <- 0.7535651
    dispatch$test("log msg local vars: {var1}, {var2}, {var3}")
  })

  expect_true(stringr::str_detect(actual, stringr::fixed("TEST ")))
  expect_true(stringr::str_detect(actual, stringr::fixed("log msg local vars: abc, 123, 0.7535651")))

  # remove the log level
  log_levels(name = "test", level = NA)

  all_levels <- log_levels()
  expect_true(all(is.na(match(all_levels, tolower(level_name(lvl))))))
})

test_that("threshold_evaluation_works", {

  test_config_file <- system.file("test-data",
                                  "test-config.yml",
                                  package = "dyn.log")

  log_config <- yaml::read_yaml(test_config_file, eval.expr = T)

  dispatch <- LogDispatchTester$new()
  dispatch$set_settings(log_config$settings)

  lvl <- new_log_level(name = "TEST",
                       description = "for testing",
                       severity = 1000L,
                       log_style = crayon::blue,
                       msg_style = crayon::silver)

  dispatch$add_log_level(lvl)

  actual <- capture_output({
    var1 <- "abc"; var2 <- 123; var3 <- 0.7535651
    dispatch$test("log msg local vars: {var1}, {var2}, {var3}")
  })

  expect_equal(actual, "")

  # remove the log level
  log_levels(name = "test", level = NA)

  all_levels <- log_levels()
  expect_true(all(is.na(match(all_levels, tolower(level_name(lvl))))))
})
