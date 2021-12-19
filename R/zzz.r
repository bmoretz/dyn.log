#' Global Logger
Logger <- NULL

#' @title Initialization
#'
#' Package initialization routine.
#'
#' @param libname library name
#' @param pkgname package name
.onLoad = function (libname, pkgname) {

  assign('namespace', pkgname, envir = topenv())

  assign('Logger', LogDispatch$new(), envir = topenv())

  default_config <- system.file("default.yaml",
                                package = pkgname)

  set_log_configuration(default_config, envir = topenv())

  invisible()
}
