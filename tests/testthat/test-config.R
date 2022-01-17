test_that("load_log_config_works", {

  test_config_file <- system.file("test-data",
                                  "test-config.yaml",
                                  package = "dyn.log")

  test_envir <- rlang::new_environment(list(
    Logger = LogDispatch$new()
  ))

  set_log_configuration(test_config_file, envir = test_envir)

  settings <- test_envir$Logger$get_settings()

  expect_equal(settings$threshold, "TRACE")
  expect_true(!is.null(settings$callstack))
  expect_equal(settings$callstack$max, 5)
  expect_equal(settings$callstack$start, -1)
  expect_equal(settings$callstack$stop, -1)

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

})

test_that("set_settings_works", {

  test_config_file <- system.file("test-data",
                                  "test-config.yaml",
                                  package = "dyn.log")

  test_envir <- rlang::new_environment(list(
    Logger = LogDispatch$new()
  ))

  set_log_configuration(test_config_file, envir = test_envir)

  config <- yaml::read_yaml(test_config_file, eval.expr = T)

  configure_logger(config$settings)

  settings <- Logger$get_settings()

  expect_true(!is.null(settings))

  with(settings,{
    expect_equal(threshold, config$settings$threshold)
    expect_true(!is.null(callstack))
    expect_equal(callstack$max, config$settings$callstack$max)
    expect_equal(callstack$start, config$settings$callstack$start)
    expect_equal(callstack$stop, config$settings$callstack$stop)
  })

  Logger$set_settings(settings)

  with(Logger$get_settings(),{
    expect_equal(threshold, config$settings$threshold)
    expect_true(!is.null(callstack))
    expect_equal(callstack$max, config$settings$callstack$max)
    expect_equal(callstack$start, config$settings$callstack$start)
    expect_equal(callstack$stop, config$settings$callstack$stop)
  })
})

test_that("get_configurations_works", {

  log_configs <- get_configurations()

  expect_true(!is.null(log_configs$default))
  expect_true(!is.null(log_configs$knitr))
  expect_true(!is.null(log_configs$object))

})

test_that("object_config_works", {

  test_config_file <- system.file("test-data",
                                  "test-object.yaml",
                                  package = "dyn.log")

  test_envir <- rlang::new_environment(list(
    Logger = LogDispatch$new()
  ))

  set_log_configuration(test_config_file, envir = test_envir)

  test_obj <- DerivedTestObject$new()

  actual <- capture_output_lines({
    test_obj$invoke_logger()
  })

  expect_equal(length(actual), 2)

  expect_true(stringr::str_detect(actual[1], stringr::fixed("Object Id:")))
  expect_true(stringr::str_detect(actual[1], stringr::fixed(test_obj$id)))

  expect_true(stringr::str_detect(actual[2], stringr::fixed("TRACE")))
  expect_true(stringr::str_detect(actual[2], stringr::fixed("derived test - 321 - 200")))
})
