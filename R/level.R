#' @title Log Level
#'
#' @description S3 object to represent a typed & predefined log level.
#'
#' @param name name of the log level is the string representation.
#' @param severity log severity is used in determining if a message should get
#' displayed according to the currently set evaluation threshold.
#' @param log_style is a {crayon::style()} that will colorize the log level.
#' @param msg_style is a {crayon::style()} style that will gray scale the log message, with
#' typically inverted strength, according to the severity.
#'
#' @section Severity:
#'
#' \itemize{
#'  \item{"FATAL"} : {The FATAL level designates very severe error events that will presumably lead the application to abort.}
#'  \item{"ERROR"} : {The ERROR level designates error events that might still allow the application to continue running.}
#'  \item{"WARN"} : {The WARN level designates potentially harmful situations.}
#'  \item{"SUCCESS"} : {The SUCCESS level designates that the operation was unencumbered.}
#'  \item{"INFO"} : {The INFO level designates informational messages that highlight the progress of the application at coarse-grained level.}
#'  \item{"DEBUG"} : {The DEBUG Level designates fine-grained informational events that are most useful to debug an application.}
#'  \item{"TRACE"} : {The TRACE Level designates finer-grained informational events than the DEBUG}
#' }
#'
#' @return new [log_level]
#' @export
new_log_level <- function(name,
                          severity,
                          log_style = NULL,
                          msg_style = NULL) {

  if(!is.integer(severity) || severity < 0)
    stop('invalid severity level')

  if(!is.character(name) || nchar(name) == 0)
    stop('invalid log level')

  new_level <- structure(
    list(),
    name = name,
    severity = severity,
    log_style = log_style,
    msg_style = msg_style,
    class = c(name, 'log_level')
  )

  levels <- attr(new_log_level, 'levels')

  if(is.null(levels)) {
    levels <- list()
  }

  levels[[name]] <- new_level

  attr(new_log_level, 'levels') <<- levels

  new_level
}

#' Gets Defined Log Levels
#'
#' @return defined log levels
#' @export
log_levels <- function() {
  attr(new_log_level, 'levels')
}

#' @title Get Level Name
#'
#' @description gets the name of the log level.
#'
#' @param level log level
#'
#' @return log level name
#' @export
level_name <- function(level) {
  UseMethod('level_name', level)
}

#' @title Get Level Name
#'
#' @description gets the name of the log level.
#'
#' @param level log level
#'
#' @return log level name
#' @export
level_name.log_level <- function(level) {
  return(attr(level, 'name'))
}

#' @title Get Level Name
#'
#' @description gets the name of the log level though
#' casting to a character and forwarding the call
#' to get_level_name.
#'
#' @param x log level
#' @param ... ignored
#' @return log level name
#' @export
#' @method as.character log_level
as.character.log_level <- function(x, ...) {
  return(level_name(x))
}

#' @title get level severity
#'
#' @param level log level
#'
#' @return level severity
#' @export
level_severity <- function(level) {
  UseMethod('level_severity', level)
}

#' Gets the severity of a log level.
#'
#' @param level log level
#'
#' @return level severity
#' @export
#'
#' @examples
#' get_severity(FATAL)
level_severity <- function(level) {
  return(attr(level, 'severity'))
}

#' Gets the severity of a log level.
#'
#' @param x log level
#' @param ... ignored
#' @return log level
#' @export
#' @method as.integer log_level
as.integer.log_level <- function(x, ...) {
  return(level_severity(x))
}

#' Gets style level information
#'
#' @param level log level
#'
#' @return styled level information
#' @export
level_info <- function(level) {
  UseMethod("level_info", level)
}

#' Gets style level information
#'
#' @param level log level
#'
#' @return styled level information
#' @export
level_info <- function(level) {
  attr(level, 'log_style')(level_name(level))
}

#' Get log level message format
#'
#' @param level log level
#' @param msg log msg
#' @return formatted log message
#' @export
format.log_level <- function(level, msg) {
  attr(level, 'msg_style')(msg)
}

#' Gets style level information
#'
#' @param level log level
#'
#' @return styled level information
#' @export
level_info <- function(level) {
  attr(level, 'log_style')(level_name(level))
}
