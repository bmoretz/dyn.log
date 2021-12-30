test_that("load_log_config_works", {

  test_config_file <- system.file("test-data",
                                  "test-config.yml",
                                  package = "dyn.log")

  test_envir <- rlang::new_environment(list(
    Logger = LogDispatchTester$new()
  ))

  settings <- test_envir$Logger$get_settings()

  expect_equal(settings$threshold, "TRACE")
  expect_true(!is.null(settings$callstack))
  expect_equal(settings$callstack$max, 5)
  expect_equal(settings$callstack$start, -1)
  expect_equal(settings$callstack$stop, -1)

  set_log_configuration(test_config_file, envir = test_envir)

  log_levels <- log_levels()

  expect_true(any(match(log_levels, 'trace')))
  expect_true(any(match(log_levels, 'debug')))
  expect_true(any(match(log_levels, 'info')))
  expect_true(any(match(log_levels, 'success')))
  expect_true(any(match(log_levels, 'warn')))
  expect_true(any(match(log_levels, 'error')))
  expect_true(any(match(log_levels, 'critical')))
  expect_true(any(match(log_levels, 'fatal')))

  with(test_envir$Logger$get_settings(), {
    expect_equal(threshold, "TRACE")
  })

  log_levels("STRACE", NULL)
  log_levels("CRITICAL", NULL)
})
