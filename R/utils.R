#' @importFrom grDevices col2rgb
NULL

# Adds utilities that are used in various functions

# Adopted from Shiny
`%OR%` <- function(x, y) {
  if (is.null(x) || isTRUE(is.na(x)))
    y
  else
    x
}

# Adopted from Shiny
`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}

firstChoice <- function(choices) {
  if (length(choices) == 0L) return()
  choice <- choices[[1]]
  if (is.list(choice)) firstChoice(choice) else choice
}

idFromTitle <- function(x) invisible(tolower(gsub('[^[:alnum:]]', '', x)))

is.tab <- function(x) {
  inherits(x, 'shiny.tag') && !is.null(x$attribs$role) && x$attribs$role == 'tabpanel'
}

# TODO: add variations (like WordPress?)
esc <- function(x) {
  gsub('[^A-Za-z0-9]', '', x)
}

lightColor <- function(color) {
  if (!grepl('^#', color)) color <- paste0('#', color)
  color <- col2rgb(color)
  return(sqrt(0.299*(color[1]^2)+0.587*(color[2]^2)+0.114*(color[3]^2)) > 127.5)
}
