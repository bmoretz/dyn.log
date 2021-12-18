#' Format Layout
#'
#' @description
#' Base type for log format objects.
#' @param style [crayon] that the layout will use in log generation.
#'
#' @family Log Layout
#' @return new log format
#' @export
new_fmt_layout <- function(style) {

  stopifnot(class(style) != "crayon")

  structure(
    list(),
    style = style,
    class = c("fmt_layout")
  )
}

#' @title Value
#'
#' @description
#' Base method for getting the value of a
#' format object.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value <- function(fmt, ...) {
  UseMethod("value", fmt)
}

#' Formatted Metric
#'
#' @description
#' Inserts a formatted log metric.
#'
#' @param style that the layout will use in log generation
#' @param metric the metric to log.
#'
#' @seealso [LogDispatch]
#' @family Log Layout
#' @return a new formatted metric
#' @export
#'
#' @examples
#' new_fmt_metric(bold $ green, "sysname")
#'
#' new_fmt_metric(bold $ red, "release")
new_fmt_metric = function(style, metric) {
  stopifnot(class(style) == "crayon")

  if(!is.character(metric) || nchar(metric) == 0)
    stop("invalid log metric specified")

  structure(
    list(),
    style = style,
    metric = metric,
    class = c('fmt_metric', 'fmt_layout')
  )
}

#' Gets the style of a format object.
#'
#' @param fmt object to extract value from.
#'
#' @return object's value
#' @export
style <- function(fmt) {
  UseMethod("style", fmt)
}

#' Gets the style of a format object.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
style.fmt_layout <- function(fmt, ...) {
  attr(fmt, 'style')
}

#' @title Value
#'
#' @description
#' Generic override for getting the value of an
#' system info variable.
#'
#' @param fmt object to extract value from.
#' @param sys_context context to evaluate the metric.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value.fmt_metric <- function(fmt, sys_context, ...) {
  style(fmt)(get(attr(fmt, 'metric'), sys_context))
}

#' Formatted Literal
#'
#' @description
#' Placeholder for a formatted literal in a log layout.
#'
#' @param style format style (crayon)
#' @param literal log value
#'
#' @family Log Layout
#' @returns log metric layout.
#' @examples
#' new_fmt_literal(red $ bold, "literal text")
#'
#' new_fmt_literal(blue $ italic, "literal text")
new_fmt_literal <- function(style, literal) {
  structure(
    list(),
    style = style,
    value = literal,
    class = c('fmt_literal', 'fmt_layout')
  )
}

#' @title Value
#'
#' @description
#' Generic override for getting the value of a
#' literal log message.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value.fmt_literal <- function(fmt, ...) {
  style(fmt)(attr(fmt, 'value'))
}

#' Formatted Timestamp
#'
#' @description
#' Placeholder for a formatted timestamp in a log layout.
#'
#' @param style format style (crayon)
#' @param format timestamp format, defaults to: %x %H:%M:%S %z,
#' e.g., 12/04/21 14:31:25 -0500
#'
#' @family Log Layout
#' @returns log metric layout.
#' @examples
#' fmt_timestamp(red $ bold, "%Y-%m-%d %H:%M:%S")
#'
#' fmt_timestamp(blue $ italic, "%x %H:%M:%S %z")
new_fmt_timestamp <- function(style,
                              format = "%x %H:%M:%S %z") {
  structure(
    list(),
    style = style,
    format = format,
    value = rlang::as_function(~ format(Sys.time(), .)),
    class = c('fmt_timestamp', 'fmt_layout')
  )
}

#' Gets the format of a format object.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
format.fmt_timestamp <- function(fmt, ...) {
  attr(fmt, 'format')
}

#' @title Value
#'
#' @description
#' Generic override for getting the value of a
#' formatted timestamp.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value.fmt_timestamp <- function(fmt, ...) {
  v <- attr(fmt, 'value')
  f <- attr(fmt, 'format')

  style(fmt)(v(f))
}

#' Formatted Line Break
#'
#' @description
#' Placeholder for a new line in a log layout.
#'
#' @family Log Layout
#' @returns log layout newline.
new_fmt_line_break <- function() {
  structure(
    list(),
    style = crayon::black,
    value = '\n',
    class = c('fmt_newline', 'fmt_layout')
  )
}

#' @title Value
#'
#' @description
#' Generic override for getting the value of a
#' new line placeholder.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value.fmt_newline <- function(fmt, ...) {
  attr(fmt, 'value')
}

#' Formatted Log Level
#'
#' @description
#' Placeholder for the formatted log level in a log layout.
#'
#' @family Log Layout
#' @returns log level info.
new_fmt_log_level <- function() {
  structure(
    list(),
    style = crayon::black,
    value = glue::as_glue("{level_info(level)}"),
    class = c('fmt_level_info', 'fmt_layout')
  )
}

#' @title Value
#'
#' @description
#' Generic override for getting the value for
#' log level information.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value.fmt_level_info <- function(fmt, ...) {
  attr(fmt, 'value')
}

#' @title
#' Formatted Messaged, based on log level
#'
#' @description
#' Placeholder for the log msg in a log layout.
#'
#' @family Log Layout
#' @returns log layout newline.
new_fmt_log_msg <- function() {
  structure(
    list(),
    style = crayon::black,
    value = glue::as_glue("{format(level, msg = {log_msg})}"),
    class = c('new_fmt_log_msg', 'fmt_layout')
  )
}

#' @title Value
#'
#' @description
#' Generic override for getting the value of an
#' log format message.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value.new_fmt_log_msg <- function(fmt, ...) {
  attr(fmt, 'value')
}

#' @title
#' Formatted field from the calling class scope.
#'
#' @description
#' Placeholder for a container class field
#'
#' @family Log Layout
#' @returns \code{new_fmt_cls_field}
new_fmt_cls_field <- function(style, field) {

  stopifnot(class(style) == "crayon")

  if(!is.character(field) || nchar(field) == 0)
    stop("invalid cls field specified")

  structure(
    list(),
    style = style,
    field = field,
    class = c('fmt_cls_field', 'fmt_layout')
  )
}

#' @title Value
#'
#' @description
#' Generic override for getting the value of an
#' enclosing class variable.
#'
#' @param fmt object to extract value from.
#' @param cls_context class scope to evaluate with.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value.fmt_cls_field <- function(fmt, cls_context, ...) {
  value <- get(attr(fmt, 'field'), cls_context)
  style(fmt)(value)
}

#' @title
#' Formatted variable from the execution scope.
#'
#' @description
#' Placeholder for an execution scope variable.
#'
#' @family Log Layout
#' @returns \code{new_fmt_cls_field}
new_fmt_exec_scope <- function(style, field) {

  stopifnot(class(style) == "crayon")

  if(!is.character(field) || nchar(field) == 0)
    stop("invalid execution scope field specified")

  structure(
    list(),
    style = style,
    field = field,
    class = c('fmt_exec_scope', 'fmt_layout')
  )
}

#' @title Value
#'
#' @description
#' Generic override for getting the value of an
#' execution scope variable.
#'
#' @param fmt object to extract value from.
#' @param env_context class scope to evaluate with.
#' @param ... further arguments passed to or from other methods.
#'
#' @return object's value
#' @export
value.fmt_exec_scope <- function(fmt, env_context, ...) {
  value <- get(attr(fmt, 'field'), env_context)
  style(fmt)(value)
}
