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
