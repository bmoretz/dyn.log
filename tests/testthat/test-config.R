testthat::test_that(
  desc = "initialization_works",
  code = {

      test_config_file <- system.file("test-data",
                                    "test-config.yaml",
                                    package = "dyn.log")

      invisible(testthat::capture_output_lines({
        init_logger(file_path = test_config_file)
      }))

      settings <- Logger$get_settings()

      expect_equal(settings$threshold, "TRACE")
      expect_true(!is.null(settings$callstack))
      expect_equal(settings$callstack$max, 5)
      expect_equal(settings$callstack$start, -1)
      expect_equal(settings$callstack$stop, -1)

      log_levels <- log_levels()

      expect_true(any(match(log_levels, "trace")))
      expect_true(any(match(log_levels, "debug")))
      expect_true(any(match(log_levels, "info")))
      expect_true(any(match(log_levels, "success")))
      expect_true(any(match(log_levels, "warn")))
      expect_true(any(match(log_levels, "error")))
      expect_true(any(match(log_levels, "critical")))
      expect_true(any(match(log_levels, "fatal")))

      with(Logger$get_settings(), {
        expect_equal(threshold, "TRACE")
      })
  }
)

testthat::test_that(
  desc = "get_configurations_works",
  code = {

    log_configs <- get_configurations()

    expect_true(!is.null(log_configs$default))
    expect_true(!is.null(log_configs$knitr))
    expect_true(!is.null(log_configs$object))
})

testthat::test_that(
  desc = "object_config_works",
  code = {

    test_config_file <- system.file("test-data",
                                    "test-object.yaml",
                                    package = "dyn.log")

    invisible(testthat::capture_output_lines({
      init_logger(file_path = test_config_file)
    }))

    test_obj <- DerivedTestObject$new()

    actual <- capture_output_lines({
      test_obj$invoke_logger()
    })

    expect_equal(length(actual), 2)

    expect_true(stringr::str_detect(actual[1], stringr::fixed("Object Id:")))
    expect_true(stringr::str_detect(actual[1], stringr::fixed(test_obj$identifier())))

    expect_true(stringr::str_detect(actual[1], stringr::fixed("Class:")))
    expect_true(stringr::str_detect(actual[1], stringr::fixed(test_obj$class_name())))

    expect_true(stringr::str_detect(actual[2], stringr::fixed("TRACE")))
    expect_true(stringr::str_detect(actual[2], stringr::fixed("derived test - 321 - 200")))
  }
)

testthat::test_that(
  desc = "no_var_failes",
  code = {

    test_config_file <- system.file("test-data",
                                    "test-no-var.yaml",
                                    package = "dyn.log")
    expect_error({
      init_logger(file_path = test_config_file)
    })
  }
)

testthat::test_that(
  desc = "options_variable_works",
  code = {

    test_config_file <- system.file("test-data",
                                    "test-object.yaml",
                                    package = "dyn.log")

    options("dyn.log.config" = test_config_file)

    config_specification()

    test_obj <- DerivedTestObject$new()

    actual <- capture_output_lines({
      test_obj$invoke_logger()
    })

    expect_equal(length(actual), 2)

    expect_true(stringr::str_detect(actual[1], stringr::fixed("Object Id:")))
    expect_true(stringr::str_detect(actual[1], stringr::fixed(test_obj$identifier())))

    expect_true(stringr::str_detect(actual[1], stringr::fixed("Class:")))
    expect_true(stringr::str_detect(actual[1], stringr::fixed(test_obj$class_name())))

    expect_true(stringr::str_detect(actual[2], stringr::fixed("TRACE")))
    expect_true(stringr::str_detect(actual[2], stringr::fixed("derived test - 321 - 200")))
  }
)
