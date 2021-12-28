#' Log Layout
#'
#' @description
#' a class that stores a collection of log format objects
#' and understands how to associate a given format to
#' a class of objects.
#'
#' @param format collection of format objects to initialize with.
#' @param seperator format entry separator, defaults to a single space.
#' @param new_line the layout separator that is inserted between lines.
#' @param association objects to associate this log format with.
#' @family Log Layout
#' @return object's value
#' @export
new_log_layout <- function(format = list(),
                           seperator = " ",
                           new_line = "\n",
                           association = character()) {

  if (!is.list(format) || length(format) < 0)
    stop("layouts must contain at least one format")

  new_log_layout <- structure(
    list(),
    format = format,
    separator = seperator,
    new_line = "\n",
    association = association,
    class = c("log_layout")
  )

  log_layouts(association, new_log_layout)

  invisible(new_log_layout)
}

#' @title Log Layouts
#'
#' @description
#' an active binding to keep track of log layouts created
#' with \code{new_log_layout}.
#'
#' @param association named association to the layout
#' @param layout log layout to add if not already existing.
#'
#' @return defined log layouts
#' @export
log_layouts <- local({

  layouts <- list()

  function(association = character(0), layout = NULL) {

    if (!identical(association, character(0))) {

      if (!is.null(layout)) {

        if (missing(association)) {
          layouts[[association]]
        } else {
          layouts[[association]] <<- layout
        }

      }
      else if (association %in% names(layouts)) {
        return(layouts[[association]])
      }
    }

    invisible(layouts)
  }
})

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
#' @export
log_layout_detail <- function(layout) {
  fmt_objs <- attr(layout, "format")
  fmt_types <- unique(c(sapply(fmt_objs, function(format) class(format))))
  layout_detail <- list("formats" = fmt_objs,
                        "types" = fmt_types,
                        "seperator" = attr(layout, "separator"),
                        "new_line" = attr(layout, "new_line"))
  class(layout_detail) <- "log_layout_detail"
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
  length(attr(x, "format"))
}

#' A container for a set of formatters that specify the log
#' entry layout.
#'
#' @param formats the layout formats needed for evaluation.
#' @param types the distinct list of format types in the layout.
#' @param seperator the layout separator that is inserted between entries.
#' @param context a list of contexts needed to evaluate formats in the
#' the layout.
#' @param new_line the layout separator that is inserted between lines.
#'
#' @family Log Layout
#' @return evaluated log layout
#' @export
evaluate_layout <- function(formats, types, seperator, context,
                           new_line = "\n") {

  range <- 1:(length(formats))
  groups <- list(range)
  new_lines <- numeric(0L)

  if (any(!is.na(match(types, "fmt_newline")))) {
    is_break <- sapply(formats, function(fmt) "fmt_newline" %in% class(fmt))
    groups <- split(range, with(rle(is_break), rep(cumsum(!values), lengths)))
    new_lines <- which(is_break, arr.ind = T)
  }

  output <- character(0)

  for (group in groups) {

    rng <- unlist(unname(group))
    has_break <- any(rng %in% new_lines)

    if (has_break == T) {
      rng <- rng[-length(rng)]
    }

    evaluated <- sapply(formats[rng], function(fmt) {
      fmt_class <- class(fmt)
      fmt_type <- fmt_class[which(fmt_class != "fmt_layout")]

      value(fmt, context[[fmt_type]])
    })

    line <- paste0(evaluated, collapse = seperator)

    output <- paste0(output, line)

    if (has_break) {
      output <- paste0(output,
                       character(0),
                       seperator = new_line)
    }
  }

  output
}
