test_that("log_single_instance", {

  inst_n <- LogDispatch$new()
  inst_m <- LogDispatch$new()

  expect_true(identical(inst_n, inst_m))
})

test_that("has_system_metrics", {

  context <- sys_context()

  expect_named(context['sysname'])
  expect_gt(nchar(context['sysname']), 0)

  expect_named(context['release'])
  expect_gt(nchar(context['release']), 0)

  expect_named(context['version'])
  expect_gt(nchar(context['version']), 0)

  expect_named(context['nodename'])
  expect_gt(nchar(context['nodename']), 0)

  expect_named(context['machine'])
  expect_gt(nchar(context['machine']), 0)

  expect_named(context['login'])
  expect_gt(nchar(context['login']), 0)

  expect_named(context['user'])
  expect_gt(nchar(context['user']), 0)

  expect_named(context['r_ver'])
  expect_gt(nchar(context['r_ver']), 0)
})

test_that("default_log_dispatch_works", {
  log <- LogDispatch$new()

  output <- capture_output_lines({
    log$trace("test")
  })

  expect_gt(length(output), 0)
  expect_gt(nchar(output), 0)
})

test_that("can_add_log_level", {

  logger <- LogDispatch$new()

  test_level <- new_log_level("TEST", "test level", 100L,
                              log_style = crayon::bgGreen$italic,
                              msg_style = crayon::cyan$bold)


  logger$private$settings$threshold <- "TEST"

  expect_true(!is.null(test_level))

  actual <- capture_output({
    var1 <- "abc"; var2 <- 123; var3 <- 0.7535651
    logger$add_log_level(test_level)$test("log msg local vars: {var1}, {var2}, {var3}")
  })

  logger$private$settings$threshold <- "TRACE"

  expect_true(stringr::str_detect(actual, stringr::fixed("TEST ")))
  expect_true(stringr::str_detect(actual, stringr::fixed("log msg local vars: abc, 123, 0.7535651")))
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
