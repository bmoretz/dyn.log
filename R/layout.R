#' Log Layout
#'
#' @description
#' a class that stores a collection of log format objects
#' and understands how to associate a given format to
#' a class of objects.
#'
#' @param ... collection of format objects to initialize with.
#' @param sep format entry separator, defaults to a single space.
#' @param association objects to associate this log format with.
#' @family Log Layout
#' @return object's value
#' @export
new_log_layout <- function(...,
                           sep = ' ',
                           association = character()) {
  new_layout <- structure(
    list(),
    format = list(...),
    separator = sep,
    association = association,
    class = c('log_layout')
  )

  if(identical(character(), character())) {
    return(new_layout)
  }

  layouts <- attr(new_log_layout, 'layouts')

  if(is.null(layouts)) {
    layouts <- list()
  }

  layouts[[association]] <- new_layout

  attr(new_log_layout, 'layouts') <<- layouts

  new_layout
}

#' @title Log Layouts
#'
#' @description
#' Gets all available log layouts.
#'
#' @return all layouts.
#' @export
log_layouts <- function() {
  attr(new_log_layout, 'layouts')
}

#' @title Get Log Layout
#'
#' @description
#' Gets a log layout by cls assocation.
#'
#' @return log layout associated with cls name.
#' @export
get_log_layout <- function(association) {
  layouts <- log_layouts()

  if(association %in% layouts) {
    return(layouts[[association]])
  }

  NULL
}

#' Generic override for length of a log layout.
#'
#' @param x log format
#' @param ... further arguments passed to or from other methods.
#' @return number of formats in the layout.
#' @export
length.log_layout <- function(x, ...) {
  length(attr(x, 'format'))
}

#' A container for a set of formatters that specify the log
#' entry layout.
#'
#' @param layout collection of format objects to initialize with.
#' @param association class of objects to associate this format with.
#' @param ... further arguments passed to or from other methods.
#' @family Log Layout
#' @return evaluated log layout
#' @export
value.log_layout = function(layout, ...) {

  format <- attr(layout, 'format')
  separator <- attr(layout, 'separator')

  range <- 1:(length(format))
  is_break <- sapply(format, function(fmt) 'fmt_newline' %in% class(fmt))
  groups <- split(range, with(rle(is_break), rep(cumsum(!values), lengths)))
  new_lines <- which(is_break, arr.ind = T)

  output <- character(0)

  for(group in groups) {

    rng <- unlist(unname(group))
    has_break <- as.logical(max(new_lines %in% rng))

    if(has_break == T) {
      rng <- rng[-length(rng)]
    }

    result <- paste(sapply(format[rng], function(fmt)
      value(fmt)), sep = separator, collapse = separator)

    output <- paste0(output, result)

    if(has_break) {
      output <- paste0(output,
                       character(0),
                       separator = "\n")
    }
  }

  output
}
