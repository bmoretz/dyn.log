#' @title LogDispatch
#'
#' @description
#' R6 Class that dispatches log messages throughout the application.
#'
#' @details
#' This object is designed to a centralized logging dispatcher that
#' renders log messages with the appropriate context of the calling
#' object. The [LogLayout] object is used to generate log message
#' layouts (render formats), which are used by the [LogDispatcher]
#' to render highly-customizable and detailed log messages.
#'
#' @section Metrics:
#'
#' System Context
#'
#' \itemize{
#'  \item{"sysname"} : {The operating system name.}
#'  \item{"release"} : {The OS release.}
#'  \item{"version"} : {The OS version.}
#'  \item{"nodename"} : {A name by which the machine is known on the network (if any).}
#'  \item{"machine"} : {A concise description of the hardware, often the CPU type.}
#'  \item{"login"} : {The user's login name, or "unknown" if it cannot be ascertained.}
#'  \item{"user"} : {The name of the real user ID, or "unknown" if it cannot be ascertained.}
#'  \item{"r-ver"} : {R Version [major].[minor]}
#' }
#'
#' @seealso LogLevel
#' @docType class
#' @family Logging
#' @importFrom R6 R6Class
#' @export
LogDispatch <- R6::R6Class(
  classname = "LogDispatch",
  lock_objects = F,
  lock_class = F,
  cloneable = F,
  portable = F,

  public = list(

    #' @description
    #' Creates a new instance of a log config.
    #' @return A new `LogLayout` object.
    initialize = function() {

      if(is.null(private$public_bind_env)) {
        private$create_singleton()
      } else {
        self <- private$instance
        private$set_bindings()
      }
    },

    #' @description
    #' Public wrapper around system context used
    #' when evaluating log layouts.
    #' @return system context for logging metrics.
    get_system_context = function() {
      private$system_context
    },

    #' @description
    #' Adds dynamic function as a short-cut to
    #' log a message with a configured level.
    #' @param level log level
    #' @return reference to self to support chaining.
    add_log_level = function(level) {

      name <- tolower(level_name(level))

      self[[name]] <- rlang::as_function(function(msg,
                                                  parent = parent.frame()) {

        caller_env <- rlang::caller_env()
        parent_env <- parent.env(caller_env)

        has_calling_class <- ifelse(is.null(parent_env$self), F, T)

        cls_scope <- list(); cls_name <- NA

        if(has_calling_class) {
          cls_name <- head(class(parent_env$self), 1)
          cls_scope <- private$get_calling_class_scope(parent_env$self)
        }

        evaluated <- value(layout)

        private$dispatcher(level, msg, evaluated,
                           cls_scope = cls_scope,
                           caller_env = parent)
      })

      invisible(self)
    },

    #' @description
    #' Public wrapper around logger settings.
    #' @return logger settings.
    get_settings = function() {
      private$settings
    }
  ),

  active = list(),

  private = list(

    settings = NA,

    # overrides from base R6
    public_bind_env = NULL,
    private_bind_env = NULL,

    system_context = NULL,

    get_calling_class_scope = function(cls) {

      values <- list()

      lapply(names(as.list(cls)), function(var) {
        value <- cls[[var]]
        if(!(class(value) %in% c('environment', 'function')))
          values[[var]] <<- value

        invisible()
      })

      values
    },

    create_singleton = function() {

      private$system_context <- sys_context()

      private$public_bind_env <- base::dynGet("public_bind_env")
      private$private_bind_env <- base::dynGet("private_bind_env")

      LogDispatch$set('private',
               'public_bind_env',
               private$public_bind_env,
               overwrite = TRUE)

      LogDispatch$set('private',
               'private_bind_env',
               private$private_bind_env,
               overwrite = TRUE)
    },

    set_bindings = function() {

      private$copy_env("public_bind_env",
                       private$public_bind_env)

      private$copy_env("private_bind_env",
                       private$private_bind_env)
    },

    copy_env = function(key, value) {

      n <- sys.nframe()

      for(idx in seq_len(n-1)) {
        parent_env <- parent.frame(idx)
        parent_keys <- ls(parent_env)

        if(any(key %in% parent_keys))
          base::assign(key, value, envir = parent_env)
      }

      invisible()
    },

    dispatcher = structure(function(level, msg,
                                    ...,
                                    cs_offset = 2,
                                    cls_scope,
                                    caller_env) {

      cs <- get_call_stack()

      # remove the framework calls from cs
      call_stack <- head(cs, length(cs) - cs_offset)
      top_call <- call_stack[1]

      # evaluate log msg within context of caller
      msg <- glue::glue(msg, .envir = caller_env)

      # formatted call stack
      call_stack <- paste0(call_stack,
                           sep = "",
                           collapse = ";")

      # evaluate the full log
      with(c(private$system_context, call_stack), {
        cat(glue::glue(...))
      })
    }, generator = quote(dispatcher))
  )
)
