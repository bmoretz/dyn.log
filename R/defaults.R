local_init <- function(pos=1) {
  assign("Logger", Logger, envir = as.environment(pos))
}
