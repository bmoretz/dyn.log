# dyn.log 0.2.4

## What's Changed
* Enhancements
  + cleaned up code coverage to  ~95%.
  + added vignette on "Configuration" to detail the steps in customizing dyn.log in client applications.
  + cleaned up all logging configurations to streamline customization.
  + added clear examples on how to setup bespoke customizations to dyn.log via config templates
  
# dyn.log 0.2.3-1

## (Patch Release)
* Enhancements
  + patch to expose configurations
  
# dyn.log 0.2.3

## What's Changed
* New Features
  + added functionality to export logging configurations that are bundled with the package so they can effectively be used as templates in consuming clients.
  + Added a configuration vignette with examples on how to use the bundled configurations as templates.
  
* Enhancements
  + cleaned up renv dependencies and git actions build cache mechanics to reduce build times.
  + added dispatch & singleton helper objects to streamline unit testing of core functionality.
  + streamlined threshold and log dispatch evaluation routine.
  + cleaned up makefile to provide a clean & efficient interface for building and deploying the package.
  + cleaned up all logging configurations and added ability to specify layouts with strings or !expr's.
  
# dyn.log 0.2.2

## What's Changed
* New Features
  + added execution context & related log formatters (call stack, top call, parent fn, etc.)
  + added vignettes for: **levels**, **formats** and **layouts**

* Enhancements
  + clearly defined context objects as structured classes.
  + added call stack & execution scope based on [rlang](https://github.com/r-lib/rlang) trace.
  + updated all vignettes to use [fansi](https://github.com/brodieG/fansi) package to display clean logging output like you would see in the terminal.
  + added callstack evaluation parameters to logging configuration to account for things like [testthat](https://github.com/r-lib/testthat) and [knitr](https://github.com/yihui/knitr)
  + general cleaned up of documentation and unit tests.
  + added a lintr github action & started working through clearing all the warnings.

# dyn.log 0.1.3-alpha

## What's Changed
* New Features
  + Log layouts are now fully configuration driven, w/ some reasonable defaults.

* Enhancements
  + cleaned up log level/layout active bindings so they don't need separate accessor methods to get instantiated objects in the bindings (by name).
  + updated the README to use fansi package to display clean logging output like you would see in the terminal.
  + refactored log layouts to have a formats parameter that specify how to render the log layout.
  + moved default layouts from code to configuration under -layouts node in config.yaml.
  + cleaned up associated unit tests & documentation. cleaned up generics 'style', 'value' and 'format'.
  + updated renv pkgs cache in the github actions CI builds to reduce build time ~90%.

# dyn.log 0.1.2-alpha

## What's Changed
* New Features
  + added codecov, R CMD Check & pkgdown github actions
  + added a pkg down site and started fleshing out basic vignettes on usage/design.

* Enhancements
  + cleaned up documentation package-wide
  + converted log levels & layouts to active bindings
  + added README that gives a solid overview of what the package is trying to achieve & how
  
# dyn.log v0.1.1-alpha

## Initial Version
  * New Features
  + baseline logging components are fully functional: levels, formats, layouts and the dispatcher.
  + pkg instantiates a singleton instance of the log dispatcher, and the default configuration will give you a fully functional logging environment.
  + cls level customization options are working as expected; you can create a log layout associated with an R6 type, and the have the logger spit out variables from the enclosing class. Example added to README.