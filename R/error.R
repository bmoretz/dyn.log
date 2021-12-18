#' Unknown Severity Warning
#'
#' @param level attempted severity level of the log dispatch.
#' @param call function call to show in the condition.
#' @param ... var args
#'
#' @return error condition
#' @export
#' @importFrom glue glue
unknown_severity_warning <- function(level, call = sys.call(-1),
                                     ...) {

  err_msg <- "Severity '{level}' is not reconized as a valid
              log level and theefore could not be processed.
              Please see the ?LogLevel for more details."

  stop(structure(
    list(
      message = strwrap(glue::glue(err_msg)),
      call = call,
      ...
    ),
    class = c("unknown_severity_warning",
              "warning",
              "condition")
  ))
}
