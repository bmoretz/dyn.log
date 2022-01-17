TestObject <- R6::R6Class(
  classname = "TestObject",

  public = list(
    id = NULL,

    initialize = function() {
      self$id <- private$generate_id()
    },

    invoke_logger = function() {
      a <- "test"; b <- 123; c <- 100L

      Logger$trace("these are some variables: {a} - {b} - {c}")
    }
  ),

  private = list(
    generate_id = function(n = 15) {
      paste0(sample(LETTERS, n, TRUE), collapse =  '')
    }
  )
)

DerivedTestObject <- R6::R6Class(
  classname = "DerivedTestObject",
  inherit = TestObject,
  public = list(
    id = NULL,

    initialize = function() {
      super$initialize()
    },

    invoke_logger = function() {
      a <- "derived test"; b <- 321; c <- 200L

      Logger$trace("variables in derived: {a} - {b} - {c}")
    }
  ),

  private = list(
    generate_id = function(n = 15) {
      paste0(sample(LETTERS, n, TRUE), collapse =  '')
    }
  )
)

UnassociatedTestObject <- R6::R6Class(
  classname = "UnassociatedTestObject",

  public = list(

    initialize = function() {},

    invoke_logger = function() {
      a <- "derived test"; b <- 321; c <- 200L
      Logger$trace("variables in derived: {a} - {b} - {c}")
    }
  ),

  active = list(),
  private = list()
)
