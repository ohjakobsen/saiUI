#' Action button
#'
#' @param inputId The input slot that will be used to access the value.
#' @param label The contents of the button or link–usually a text label, but you
#'   could also use any other HTML, like an image.
#' @param color Alternate Bootstrap 4 stylesheet.
#' @param icon An optional icon to appear on the button.
#' @param width The width of the input, e.g. \code{'400px'}, or \code{'100\%'}
#' @param ... Named attributes to be applied to the button or link.
#'
#' @export
actionButton <- function(inputId, label, color = 'primary', icon = NULL, width = NULL, ...) {

  value <- restoreInput(id = inputId, default = NULL)
  color <- paste0('btn-', color)

  tags$button(id = inputId,
              # style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
              type = 'button',
              class = paste('btn', color, 'action-button'),
              `data-val` = value,
              list(label),
              # list(validateIcon(icon), label),
              ...
  )
}

dropdownSelect <- function(inputId, label, color = '', icon = NULL, width = NULL, ...,
                           choices = c(), selected = c(), multiple = FALSE) {
  
  selected <- restoreInput(id = inputId, default = selected)
  
  
  
}
