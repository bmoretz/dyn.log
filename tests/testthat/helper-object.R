TestObject <- R6::R6Class(
  classname = "TestObject",

  public = list(
    id = NULL,

    initialize = function() {
      self$id <- private$generate_id()
    },

    test_trace = function() {
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
