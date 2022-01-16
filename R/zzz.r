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

  configs <- get_configurations(pkgname = pkgname)
  assign("configs", configs, envir = topenv())

  set_log_configuration(configs$default, envir = topenv())

  # Always register hook in case package is later unloaded & loaded
  setHook(
    packageEvent(pkgname, "onLoad"),
    function(...) {
      set_log_configuration(configs$default, envir = topenv())
    }
  )

  invisible()
}