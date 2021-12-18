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

      invisible(self)
    },

    get_system_metrics = function() {
      private$system_context
    },

    get_cls_scope = function(cls) {
      private$get_class_scope(cls)
    }
  ),
  private = list()
)
