# dyn.log 0.1.4

* Enhancements
  + focusing on cleaning up the pkgdown site, documentation, vignettes and the readme.
  
# dyn.log 0.1.3

* New Features
  + Log layouts are now fully configuration driven, w/ some reasonable defaults.

* Enhancements
  + cleaned up log level/layout active bindings so they don't need separate accessor methods to get instantiated objects in the bindings (by name).
  + updated the README to use fansi package to display clean logging output like you would see in the terminal.
  + refactored log layouts to have a formats parameter that specify how to render the log layout.
  + moved default layouts from code to configuration under -layouts node in config.yaml.
  + cleaned up associated unit tests & documentation. cleaned up generics 'style', 'value' and 'format'.
  + updated renv pkgs cache in the github actions CI builds to reduce build time ~90%.


# dyn.log 0.1.2

* New Features
  + added codecov, R CMD Check & pkgdown github actions
  + added a pkg down site and started fleshing out basic vignettes on usage/design.

* Enhancements
  + cleaned up documentation package-wide
  + converted log levels & layouts to active bindings
  + added README that gives a solid overview of what the package is trying to achieve & how
  
# dyn.log v0.1.1

* Initial Version
  + baseline logging components are fully functional: levels, formats, layouts and the dispatcher.
  + pkg instantiates a singleton instance of the log dispatcher, and the default configuration will give you a fully functional logging environment.
  + cls level customization options are working as expected; you can create a log layout associated with an R6 type, and the have the logger spit out variables from the enclosing class. Example added to README.
