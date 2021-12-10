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

TestObject <- R6::R6Class(
  classname = "TestClass",

  public = list(
    id = NULL,

    initialize = function() {
      self$id <- private$generate_id()
    },

    test_method = function() {
      a <- "test"; b <- 123; c <- 100L

      Logger$trace("these are some variables: {a} - {b} - {c}")
    }
  ),

  private = list(
    generate_id = function(n = 10) {
      paste0(do.call(paste0, replicate(5, sample(LETTERS, n, TRUE), FALSE)), collapse =  '')
    }
  )
)

test_that("can_add_log_level", {

  log_layouts()

  new_log_layout(
    new_fmt_cls_field(crayon::cyan$bold, "id"),
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
    association = "TestObject"
  )

  obj <- TestObject$new()
  obj$test_method()


  Logger$debug("testing")
})

?parent.frame


test_context <- function() {
  fn <- rlang::as_function(function(msg) {

    context <- deparse(sys.calls()[[sys.nframe()-1]])

    print(context)
  })

  fn("test")
}

test_context()
