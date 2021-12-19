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

  new_log_layout <- structure(
    list(),
    format = list(...),
    separator = sep,
    association = association,
    class = c('log_layout')
  )

  log_layouts(new_log_layout)

  invisible(new_log_layout)
}

#' @title Log Layouts
#'
#' @description
#' an active binding to keep track of log layouts created
#' with \code{new_log_layout}.
#'
#' @param layout log layout to add if not already existing.
#'
#' @return defined log layouts
#' @export
log_layouts <- local({

  layouts <- list()

  function(layout = NULL) {
    if(!is.null(layout)) {
      association <- attr(layout, 'association')
      if(!identical(association, character())) {
        if(missing(association)) {
          layouts[[association]]
        } else {
          layouts[[association]] <<- layout
        }
      }
    }

    invisible(layouts)
  }
})

#' @title Get Log Layout
#'
#' @description
#' Gets a log layout by cls assocation.
#' @param association cls assocation
#' @return log layout associated with cls name.
#' @export
get_log_layout <- function(association) {

  layouts <- log_layouts()

  if(!(association %in% names(layouts))) {
    return(NULL)
  }

  layouts[[association]]
}

#' @title Log Layout Detail
#'
#' @description
#' Gets the layout formats and the distinct format types in
#' a log layout instance, which is useful for determining
#' the appropriate amount of log context to construct.
#'
#' @param layout object to extract layout detail from.
#'
#' @return layout format
log_layout_detail <- function(layout) {
  fmt_objs <- attr(layout, 'format')
  fmt_types <- unique(c(sapply(fmt_objs, function(format) class(format))))
  layout_detail <- list('formats' = fmt_objs,
                        'types' = fmt_types,
                        'seperator' = attr(layout, 'separator'))
  class(layout_detail) <- 'log_layout_detail'
  layout_detail
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
#' @param formats the layout formats needed for evaluation.
#' @param types the distinct list of format types in the layout.
#' @param seperator the layout separator that is inserted between entries.
#' @param context a list of contexts needed to evaluate formats in the
#' the layout.
#' @family Log Layout
#' @return evaluated log layout
#' @export
evaluate_layout = function(formats, types, seperator, context) {

  range <- 1:(length(formats))
  groups <- list(range)
  new_lines <- numeric(0L)

  if(any(!is.na(match(types, 'fmt_newline')))) {
    is_break <- sapply(formats, function(fmt) 'fmt_newline' %in% class(fmt))
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

    evaluated <- sapply(formats[rng], function(fmt) {
      fmt_class <- class(fmt)
      fmt_type <- fmt_class[which(fmt_class != 'fmt_layout')]

      value(fmt, context[[fmt_type]])
    })

    line <- paste0(evaluated, collapse = seperator)

    output <- paste0(output, line)

    if(has_break) {
      output <- paste0(output,
                       character(0),
                       seperator = "\n")
    }
  }

  output
}
