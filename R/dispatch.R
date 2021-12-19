#' @title LogDispatch
#'
#' @description
#' R6 Class that dispatches log messages throughout the application.
#'
#' @details
#' This object is designed to a centralized logging dispatcher that
#' renders log messages with the appropriate context of the calling
#' object. The \code{log_layout} object is used to generate log message
#' layouts (render formats), which are used by the \code{LogDispatcher}
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
#'  \item{"r-ver"} : {R Version (major).(minor)}
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

      invisible(self)
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

        has_calling_class <- ifelse(is.null(parent_env$self), F, T); calling_class <- NA
        log_msg <- glue::glue(msg, .envir = parent)
        log_layout <- get_log_layout("default")

        if(has_calling_class) {
          calling_class <- parent_env$self

          cls_name <- head(class(calling_class), 1)

          associated_layout <- get_log_layout(cls_name)

          if(!is.null(associated_layout)) {
            log_layout <- associated_layout
          }
        }

        with(log_layout_detail(log_layout), {

          context <- list()

          if(has_calling_class && any(!is.na(match(types, 'fmt_cls_field')))) {
            context[['fmt_cls_field']] = private$get_class_scope(calling_class)
          }

          if(any(!is.na(match(types, 'fmt_metric')))) {
            context[['fmt_metric']] = sys_context()
          }

          cat(glue::glue(evaluate_layout(formats, types, seperator, context,
                                         new_line = new_line)))
        })
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

    create_singleton = function() {

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

    get_callstack = function(offset = 2) {
      cs <- get_call_stack()

      # get the maximum call stack output setting
      max_levels <- private$settings$max_callstack

      # remove the framework calls from cs
      call_stack <- head(cs, max(length(cs) - offset, max_levels))

      list(top_call = call_stack[1],
           call_stack = call_stack)
    },

    get_class_scope = function(cls) {

      values <- list()

      lapply(names(as.list(cls)), function(var) {
        value <- cls[[var]]

        if(!(class(value) %in% c('environment', 'function')))
          values[[var]] <<- value

        invisible()
      })

      values
    }
  )
)
