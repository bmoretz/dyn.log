# dyn.log 0.1.3

# dyn.log 0.1.1

* initial version of the working logging framework.
  + pkg instantiates a singleton instance of the log dispatcher, and the default configuration will give you a fully functional logging environment. 
  + cls level customization options are working as expected. you can create a log layout associated with an R6 type, and the have the logger spit out variables from the enclosing class.
