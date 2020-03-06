# Adds utilities that are used in various functions
# Several are copied from \code{shiny}

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

firstChoice <- function(choices) {
  if (length(choices) == 0L) return()
  choice <- choices[[1]]
  if (is.list(choice)) firstChoice(choice) else choice
}

controlLabel <- function(controlName, label) {
  label %AND% tags$label(class = "control-label", `for` = controlName, label)
}

idFromTitle <- function(x) invisible(tolower(gsub('[^[:alnum:]]', '', x)))
