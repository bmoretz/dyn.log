test_that("log_single_instance", {

  inst_n <- LogDispatch$new()
  inst_m <- LogDispatch$new()

  expect_true(identical(inst_n, inst_m))
})

LogDispatchTester <- R6::R6Class(
  classname = "LogDispatchTester",
  inherit = LogDispatch,
  lock_objects = F,
  lock_class = F,
  cloneable = F,
  portable = F,

  public = list(

    initialize = function() {
      super$initialize()
    },

    get_system_metrics = function() {
      private$system_context
    }

  ),
  private = list()
)

test_that("has_system_metrics", {

  log <- LogDispatchTester$new()

  expect_named(log$system['sysname'])
  expect_gt(nchar(log$system['sysname']), 0)

  expect_named(log$system['release'])
  expect_gt(nchar(log$system['release']), 0)

  expect_named(log$system['version'])
  expect_gt(nchar(log$system['version']), 0)

  expect_named(log$system['nodename'])
  expect_gt(nchar(log$system['nodename']), 0)

  expect_named(log$system['machine'])
  expect_gt(nchar(log$system['machine']), 0)

  expect_named(log$system['login'])
  expect_gt(nchar(log$system['login']), 0)

  expect_named(log$system['user'])
  expect_gt(nchar(log$system['user']), 0)

  expect_named(log$system['r-ver'])
  expect_gt(nchar(log$system['r-ver']), 0)
})

test_that("log_dispatch_01", {
  log <- LogDispatchTester$new()

  #log$trace("test")
})

test_that("can_add_log_level", {
  log <- LogDispatchTester$new()

  log$add_log_level(TRACE)

  log$trace("msg")

  #log$trace("test")
})

layout <- new_log_layout(
  new_fmt_metric(crayon::green$bold, "sysname"),
  new_fmt_metric(crayon::yellow$bold, "release"),
  new_fmt_line_break(),
  new_fmt_log_level(),
  new_fmt_timestamp(crayon::silver$italic),
  new_fmt_metric(crayon::magenta$bold, "top_call"),
  new_fmt_literal(crayon::blue$italic, "literal text"),
  new_fmt_log_msg(),
  new_fmt_line_break(),
  new_fmt_metric(crayon::cyan$bold, "call_stack"),
  association = "default"
)

layouts <- log_layouts()

test <- function() {
  outer <- function() {
    inner <- function() {
      Logger$log(ERROR, "log msg", layout = layout)
    }

    inner()
  }

  outer()
}

test()


fn <- function() {
  inner <- function(context = parent.frame()) {
    context
  }

  inner()
}

ls(fn())
