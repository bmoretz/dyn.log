#' Global Logging Instance
Logger <- LogDispatch$new()

#' @title Initialization
#'
#' Package initialization routine.
#'
#' @param libname library name
#' @param pkgname package name
.onLoad <- function(libname, pkgname) {

  assign("namespace", pkgname, envir = topenv())

  default_config <- system.file("default.yaml",
                                package = pkgname)

  set_log_configuration(default_config, envir = topenv())

  # Always register hook in case package is later unloaded & loaded
  setHook(
    packageEvent(pkgname, "onLoad"),
    function(...) {
      set_log_configuration(default_config, envir = topenv())
    }
  )

  invisible()
}
