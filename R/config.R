#' Load Log Levels
#'
#' @param file_name loads logging levels from a yml configuration file.
#' @family Logging
#' @return initialized log levels from the specified config.
#' @export
#' @importFrom yaml read_yaml
set_log_configuration <- function(file_name, envir = parent.frame()) {

  log_config <- yaml::read_yaml(file_name, eval.expr = T)

  unlockBinding('Logger', env = envir)

  configure_logger(log_config$settings, envir)
  attach_log_levels(log_config$levels, envir)

  lockBinding('Logger', env = envir)

  invisible()
}

attach_log_levels <- function(levels, envir) {

  for(level in levels) {

    new_level <- new_log_level(name = level$name,
                               severity = level$severity,
                               log_style = level$log_style,
                               msg_style = level$msg_style)

    envir$Logger$add_log_level(new_level)

    assign(level$name, new_level, envir = envir)
  }

  invisible()
}

configure_logger <- function(settings, envir) {
  envir$Logger$.__enclos_env__$private$settings <- settings
}
