#' @title Set Logging Configuration
#'
#' @description loads the logging configuration from the
#' yaml config file and loads the appropriate objects
#' into the specified environment.
#'
#' @param file_name loads logging levels from a yml configuration file.
#' @param envir environment to load logger into.
#'
#' @family Logging
#' @return initialized log levels from the specified config.
#'
#' @export
#' @importFrom yaml read_yaml
set_log_configuration <- function(file_name, envir = parent.frame()) {

  log_config <- yaml::read_yaml(file_name, eval.expr = T)

  configure_logger(log_config$settings, envir)

  attach_log_levels(log_config$levels)
  load_log_layouts(log_config$layouts)

  local_init()

  invisible()
}

#' @title Load Log Levels
#'
#' @description
#' Parses and loads the levels specified in the
#' logging configuration and registers them with the
#' dispatcher via the \code{log_levels} active
#' binding.
#'
#' @param levels defined in the configuration
#'
#' @family Logging
#'
#' @importFrom stringr str_split str_trim
attach_log_levels <- function(levels) {

  for (level in levels) {

    new_level <- new_log_level(name = level$name,
                               description = level$description,
                               severity = level$severity,
                               log_style = level$log_style,
                               msg_style = level$msg_style)

    Logger$add_log_level(new_level)
  }

  invisible()
}

#' @title Load Log Layouts
#'
#' @description
#' Parses and loads layouts specified in the logging
#' configuration and registers them with the log
#' dispatcher via the \code{log_layouts} active
#' binding.
#'
#' @param layouts defined in the configuration
#'
#' @family Logging
#'
#' @importFrom stringr str_split str_trim
load_log_layouts <- function(layouts) {

  for (layout in layouts) {

    parsed <- stringr::str_split(layout$formats, pattern = ",", simplify = T)

    formats <- sapply(parsed, function(fmt) {
      eval(parse(text = stringr::str_trim(fmt)))
    })

    new_layout <- new_log_layout(
      format = formats,
      seperator = layout$seperator,
      new_line = layout$new_line,
      association = layout$association
    )
  }
}

configure_logger <- function(settings, envir) {
  envir$Logger$.__enclos_env__$private$settings <- settings
}

#' @title Display Log Levels
#'
#' @description
#' A utility function that dynamically displays the configured
#' log levels (loaded from config), and outputs them in a simple
#' layout with only the log level and msg formatted in their
#' crayon styles.
#'
#' @family Logging
#' @return Nothing.
#'
#' @export
#' @importFrom yaml read_yaml
display_log_levels <- function() {
  sapply(log_levels(), function(level) {
    info <- level_info(level)
    fn <- Logger[[tolower(info$name)]]

    if (is.function(fn)) {
      fn(msg = info$description, layout = "level_msg")
      cat("\n")
    }
  })

  invisible(NULL)
}
