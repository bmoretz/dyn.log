#' Mock Logger
#'
#' Used to test internals of a Logger
#' instantiated via configuration.
#'
TestLogger <- R6::R6Class(
  classname = "TestLogger",
  inherit = LogDispatch,
  portable = F,
  public = list(

    initialize = function() {
      super$initialize()
    }
  )
)

test_that("load_log_config_works", {

  test_config_file <- system.file("test-data",
                                  "test-layout.yml",
                                  package = "dyn.log")

  test_envir <- rlang::new_environment(list(
    Logger = TestLogger$new()
  ))

  load_log_configuration(test_config_file, envir = test_envir)

  env_vars <- ls(test_envir)

  expect_true(any(match(env_vars, 'STRACE')))
  expect_true(any(match(env_vars, 'TRACE')))
  expect_true(any(match(env_vars, 'DEBUG')))
  expect_true(any(match(env_vars, 'INFO')))
  expect_true(any(match(env_vars, 'SUCCESS')))
  expect_true(any(match(env_vars, 'WARN')))
  expect_true(any(match(env_vars, 'ERROR')))
  expect_true(any(match(env_vars, 'CRITICAL')))
  expect_true(any(match(env_vars, 'FATAL')))

  expect_equal(test_envir$Logger$settings$threshold, "TRACE")
})
