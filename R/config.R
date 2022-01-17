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

  configure_logger(log_config$settings)
  attach_log_levels(log_config$levels)
  load_log_layouts(log_config$layouts)

  init_logger()

  invisible()
}

#' @title Get Configurations
#'
#' @description
#' Gets all available logging configurations
#' exposed by the package.
#'
#' @param pkgname package name to get configs for.
#'
#' @family Logging
#'
#' @export
get_configurations <- function(pkgname = "dyn.log") {

  config_files <- list.files(
    system.file("", package = pkgname),
    pattern = ".yaml",
    full.names = T
  )

  configs <- list()

  sapply(config_files, function(fname) {
    cname <- tools::file_path_sans_ext(basename(fname))
    configs[[cname]] <<- fname
    invisible()
  })

  configs
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
                               severity = as.integer(level$severity),
                               log_style = level$log_style,
                               msg_style = level$msg_style)

    Logger$add_log_level(new_level)
  }

  invisible()
}

#' @title Init Logger
#'
#' @description
#' Attaches a reference to the global
#' logger to the top env if one doesn't
#' already exist.
#'
#' @param pos environment level (1=topenv)
#'
#' @family Logging
#'
#' @importFrom stringr str_split str_trim
init_logger <- function(pos=1) {
  envir <- as.environment(pos)

  if (!any(!is.na(match(ls(envir), "Logger")))) {
    assign("Logger", LogDispatch$new(), envir  = envir)
  }
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

    if (identical(class(layout$format), "character")) {
      parsed <- stringr::str_split(layout$formats, pattern = ",", simplify = T)

      formats <- sapply(parsed, function(fmt) {
        eval(parse(text = stringr::str_trim(fmt)))
      })
    } else {
      formats <- layout$formats
    }

    new_layout <- new_log_layout(
      format = formats,
      seperator = layout$seperator,
      new_line = layout$new_line,
      association = layout$association
    )
  }
}

#' @title Configure Logger
#'
#' @description
#' Parses and loads settings for the log dispatcher.
#'
#' @param settings loaded from config
#' @family Logging
#'
#' @importFrom stringr str_split str_trim
configure_logger <- function(settings) {
  Logger$set_settings(settings)
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

  invisible()
}
