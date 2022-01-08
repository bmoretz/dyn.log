LogDispatchTester <- R6::R6Class(
  classname = "LogDispatchTester",
  inherit = LogDispatch,
  lock_objects = F,
  lock_class = F,
  cloneable = F,
  portable = F,

  public = list(

    initialize = function() {},

    get_system_metrics = function() {
      private$system_context
    },

    get_cls_scope = function(cls) {
      private$get_class_scope(cls)
    },

    test_create_singleton = function() {
      private$create_singleton()
    },

    test_get_bind_envir = function() {
      private$get_bind_envir()
    },

    test_dispatch = function(msg,
                             parent = parent.frame(),
                             layout = "default",
                             settings,
                             level) {

      private$dispatch(msg,
                       parent = parent,
                       layout = layout,
                       settings = settings,
                       level = level)
    }
  ),
  private = list()
)

test_that("wrap_log_level_works", {

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
