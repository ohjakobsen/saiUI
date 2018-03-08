#' Adds the content of www to shinyWidgets/
#'
#' @importFrom shiny addResourcePath
#'
#' @noRd
#'
.onLoad <- function(...) {
  shiny::addResourcePath('saiUI', system.file('www', package = 'saiUI'))
}