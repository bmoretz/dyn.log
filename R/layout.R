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

  if(!identical(association, character())) {

    layouts <- attr(new_log_layout, 'layouts')

    if(is.null(layouts)) {
      layouts <- list()
    }

    layouts[[association]] <- new_layout

    attr(new_log_layout, 'layouts') <<- layouts
  }

  invisible(new_layout)
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

  if(!(association %in% names(layouts))) {
    return(NULL)
  }

  layouts[[association]]
}

#' @title Log Layout Format
#'
#' @description
#' Gets the format of a format object.
#'
#' @param fmt object to extract value from.
#' @param ... further arguments passed to or from other methods.
#'
#' @return layout format
#' @export
format.log_layout <- function(fmt, ...) {
  attr(fmt, 'format')
}

#' @title Log Layout Format Types
#'
#' @description
#' Gets the distinct format types in a log layout instance,
#' which is useful for determining the appropriate amount
#' of log context to construct.
#'
#' @param layout object to extract value from.
#'
#' @return layout format
get_format_types <- function(layout) {
  unique(c(sapply(format(layout), function(format) class(format))))
}

#' @title Log Layout Length
#'
#' @description
#' Generic override for length of a log layout that returns
#' the number of individual format objects in the layout.
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
#' @param context a list of contexts needed to evaluate formats in the
#' the layout.
#' @family Log Layout
#' @return evaluated log layout
#' @export
evaluate_layout = function(layout, context) {

  format <- format(layout)
  format_types <- get_format_types(layout)
  separator <- attr(layout, 'separator')

  range <- 1:(length(format))
  groups <- list(range)
  new_lines <- numeric(0L)

  if(any(!is.na(match(format_types, 'fmt_newline')))) {
    is_break <- sapply(format, function(fmt) 'fmt_newline' %in% class(fmt))
    groups <- split(range, with(rle(is_break), rep(cumsum(!values), lengths)))
    new_lines <- which(is_break, arr.ind = T)
  }

  output <- character(0)

  for(group in groups) {

    rng <- unlist(unname(group))
    has_break <- any(rng %in% new_lines)

    if(has_break == T) {
      rng <- rng[-length(rng)]
    }

    evaluated <- sapply(format[rng], function(fmt) {
      fmt_class <- class(fmt)
      fmt_type <- fmt_class[which(fmt_class != 'fmt_layout')]

      value(fmt, context[[fmt_type]])
    })

    line <- paste0(evaluated, collapse = separator)

    output <- paste0(output, line)

    if(has_break) {
      output <- paste0(output,
                       character(0),
                       separator = "\n")
    }
  }

  output
}
