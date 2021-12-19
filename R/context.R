#' @title Get System Info
#'
#' @description
#' Wrapper around Sys.info() that provides the values
#' in a named list format.
#'
#' @return \code{Sys.info()} as a named list
get_system_info = function() {
  as.list(Sys.info())
}

#' @title R Version
#'
#' @description
#' Wrapper around \code{R.Version()} to produce a nicely
#' formatted string for use use in sys_context.
#'
#' @return R environment version is (major).(minor) format
get_r_version = function() {
  c('r_ver' = paste0(R.Version()[c('major', 'minor')], collapse = '.'))
}

#' @title System Context
#'
#' @description
#' Wrapper around Sys.info() and \code{get_r_version} that provides
#' a consolidated list of variables used for logging contexts.
#' @return system context for evaluating \code{fmt_metric} objects.
sys_context <- function() {

  sys_info <- get_system_info()
  r_ver <- get_r_version()

  sys_context <- c(sys_info, r_ver)

  class(sys_context) <- c('sys_context')

  sys_context
}

#' @title Formatted Call Stack
#'
#' @description
#' Placeholder for the formatted call stack in a log layout.
#'
#' @param keep_args boolean to indicate if you wante to keep
#' call arguments or not.
#'
#' @family Log Layout
#' @returns formatted call stack
#' @importFrom stringr str_trim
get_call_stack = function(keep_args = F) {
  # number of levels deep
  n_levels <- length(sys.parents()) * -1
  # account for call to lapply
  frames <- seq(from = 0, to = n_levels - 1, by = -1)
  # get all frames
  call_stack <- lapply(frames, function(frame) sys.call(which = frame))
  # find where get_call_stack() is invoked
  look_back <- as.logical(match(call_stack, "get_call_stack()", nomatch = F))
  # subset to non-utility calls
  start <- which(look_back, arr.ind = T) + 1; end <- length(call_stack)

  # reverse & str format
  ret <- sapply(rev(call_stack[start:end]),
                function(fn) {
                  fn_str <- stringr::str_trim(deparse(fn))
                  ifelse(keep_args,
                         fn_str,
                         extract_func_name(fn_str))
                })

  names(ret) <- paste0("callstack_", seq(length(ret)))

  ret
}

#' @title Extract Function Name
#'
#' @description
#' Extracts the name of the function from a deparse call.
#'
#' @param func function name
#' @family Log Layout, Utility
#' @returns function name without arguments
#' @importFrom stringr str_extract
extract_func_name <- function(func) {
  stringr::str_extract(func, pattern = "[^(]+")
}
