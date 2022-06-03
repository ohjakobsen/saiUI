#' Create flexible row
#' 
#' Create a flex row using Bootstrap classes. For more information, see
#'   the \href{https://getbootstrap.com/docs/4.6/utilities/flex/}{Bootstrap documentation}
#' 
#' @param ... The elements to include in the row
#' 
#' @export
flexRow <- function(...) {
  
  div(class = 'd-flex flex-row', ...)
  
}

#' Create flexible column
#' 
#' @param ... The elements to include in the column
#' 
#' @export
flexColumn <- function(...) {
  
  div(class = 'd-flex flex-column', ...)
  
}
