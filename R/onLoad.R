#' Adds the content of www to saiUI/
#'
#' @importFrom shiny addResourcePath
#'
#' @noRd
#'
.onLoad <- function(...) {
  shiny::addResourcePath('saiUI', system.file('www', package = 'saiUI'))
}