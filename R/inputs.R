#' Action button
#'
#' @param inputId The input slot that will be used to access the value.
#' @param label The contents of the button or link–usually a text label, but you
#'   could also use any other HTML, like an image.
#' @param color Alternate Bootstrap 4 stylesheet.
#' @param outline Should the button be an outline button? Default value FALSE.
#' @param icon An optional icon to appear on the button.
#' @param width The width of the input, e.g. \code{'400px'}, or \code{'100\%'}
#' @param size The size of the button.
#' @param ... Named attributes to be applied to the button or link.
#'
#' @export
actionButton <- function(inputId, label, color = 'primary', outline = FALSE, icon = NULL,
                         width = NULL, size = c('normal', 'sm', 'lg'), ...) {

  value <- restoreInput(id = inputId, default = NULL)
  outline <- ifelse(outline, 'outline-', '')
  color <- paste0('btn-', outline, color)
  size <- match.arg(size)
  
  size <- ifelse(size %in% c('lg', 'sm'), paste0('btn-', size), '')
  icon <- ifelse(is.null(icon), '', paste0('<i class="oi oi-', icon, '"></i> '))

  tags$button(id = inputId,
              # style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
              type = 'button',
              class = paste('btn', size, color, 'action-button'),
              `data-val` = value,
              list(HTML(icon), label),
              # list(validateIcon(icon), label),
              ...
  )
}

#' Download button
#'
#' @param outputId The input slot that will be used to access the value.
#' @param label The contents of the button or link–usually a text label, but you
#'   could also use any other HTML, like an image.
#' @param color Alternate Bootstrap 4 stylesheet.
#' @param outline Should the button be an outline button? Default value FALSE.
#' @param class Optional CSS classes.
#' @param size The size of the button.
#' @param ... Named attributes to be applied to the button or link.
#'
#' @export
downloadButton <- function(outputId, label = 'Download', color = 'primary', outline = FALSE,
                           class = NULL, size = c('normal', 'sm', 'lg'), ...) {
  
  outline <- ifelse(outline, 'outline-', '')
  color <- paste0('btn-', outline, color)
  size <- match.arg(size)
  
  size <- ifelse(size %in% c('lg', 'sm'), paste0('btn-', size), '')
  icon <- '<i class="oi oi-cloud-download"></i> '
  
  aTag <- tags$a(id = outputId,
                 role = 'button',
                 class = paste('btn', size, color, 'shiny-download-link'),
                 href = '',
                 target = '_blank',
                 download = NA,
                 list(HTML(icon), label),
                 ...)
}

#' Searchbox input
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param value A character string with the default value of the search box
#' @param placeholder A character string giving the user a hint as to what can be entered into the
#'   control.
#' @param button A character string to display as the text for the search button.
#' @param color A character string giving the color of the search button.
#' @param outline Should the button be an outline button? Default value TRUE.
#' @param size A character string giving the size of the input. Valid options are \code{normal},
#'   \code{sm} and \code{lg}. Defaults to \code{normal}
#'
#' @export
searchboxInput <- function(inputId, value = '', placeholder = NULL, button = 'Search',
                           color = c('success', 'primary', 'secondary', 'danger', 'warning', 'light', 'dark'),
                           outline = TRUE, size = c('normal', 'sm', 'lg')) {
  
  outline <- ifelse(outline, 'outline-', '')
  color <- match.arg(color)
  size <- match.arg(size)
  
  size <- list(
    form = ifelse(size %in% c('lg', 'sm'), paste0(' form-control-', size), ''),
    btn = ifelse(size %in% c('lg', 'sm'), paste0(' btn-', size), '')
  )
  
  value <- shiny::restoreInput(id = inputId, default = value)
  
  div(class = 'form-group shiny-input-container',
      tags$form(class = 'form-inline searchbox px-1 my-2', style = 'width: 100%;',
                tags$input(id = inputId, type = 'text', class = paste0('form-control', size$form, ' mr-1'),
                           value = value, placeholder = placeholder),
                tags$button(id = paste0(inputId, '-btn'), class = paste0('btn btn-', outline, color, size$btn), button)
      )
  )
  
}

dropdownSelect <- function(inputId, label, color = '', icon = NULL, width = NULL, ...,
                           choices = c(), selected = c(), multiple = FALSE) {
  
  selected <- restoreInput(id = inputId, default = selected)
  
  # TODO: Implement function
  # TODO: Add documentation
  
  
}
