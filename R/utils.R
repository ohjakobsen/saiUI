#' Adds utilities that are used in various functions
#' Several are copied from `shiny`

`%OR%` <- function(x, y) {
  if (is.null(x) || isTRUE(is.na(x)))
    y
  else
    x
}

`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}

`%.%` <- function(x, y) {
  paste(x, y, sep='')
}
