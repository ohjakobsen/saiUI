#' Create an action button
#'
#' @inherit shiny::actionButton
#'
#' @param color Alternate Bootstrap 4 stylesheet.
#' @param outline Should the button be an outline button? Default value \code{FALSE}.
#' @param size The size of the button.
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

  tags$button(
    id = inputId, type = 'button',
    class = paste('btn', size, color, 'action-button'),
    `data-val` = value, list(HTML(icon), label), ...
  )
}

#' Create a download button or link
#'
#' @inherit shiny::downloadButton
#'
#' @param color Alternate Bootstrap 4 stylesheet.
#' @param outline Should the button be an outline button? Default value FALSE.
#' @param size The size of the button.
#'
#' @export
downloadButton <- function(outputId, label = 'Download', color = 'primary', outline = FALSE,
                           class = NULL, size = c('normal', 'sm', 'lg'), ...) {

  outline <- ifelse(outline, 'outline-', '')
  color <- paste0('btn-', outline, color)
  size <- match.arg(size)

  size <- ifelse(size %in% c('lg', 'sm'), paste0('btn-', size), '')
  icon <- '<i class="oi oi-cloud-download"></i> '

  aTag <- tags$a(
    id = outputId, role = 'button',
    class = paste('btn', size, color, 'shiny-download-link'),
    href = '', target = '_blank', download = NA,
    list(HTML(icon), label), ...)
}

#' File Upload Control
#'
#' Create a file upload control that can be used to upload one or more files. This function
#' is masked from \code{shiny}.
#'
#' @inherit shiny::fileInput
#'
#' @export
fileInput <- function(inputId, label, multiple = FALSE, accept = NULL, width = NULL,
                      buttonLabel = NULL, placeholder = 'Choose file') {

  inputTag <- tags$input(
    id = inputId,
    class = 'custom-file-input',
    name = inputId,
    type = 'file'
  )

  if (multiple) inputTag$attribs$multiple <- 'multiple'
  if (length(accept) > 0L)
    inputTag$attribs$accept <- paste(accept, collapse=',')

  div(
    class = 'custom-file input-group',
    inputTag,
    tags$label(
      class = 'custom-file-label',
      `for` = inputId,
      placeholder
    ),
    tags$input(
      class = 'custom-file-placeholder d-none',
      type = 'text'
    ),
    tags$div(
      id = paste(inputId, '_progress', sep=''),
      class = 'progress progress-striped active shiny-file-input-progress',
      tags$div(class = 'progress-bar')
    )
  )

}

#' Create a searchbox input
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param value A character string with the default value of the search box
#' @param placeholder A character string giving the user a hint as to what can be entered into the
#'   control.
#' @param button A character string to display as the text for the search button.
#' @param icon Name of an icon from the Open Iconic library instead of text.
#' @param color A character string giving the color of the search button.
#' @param outline Should the button be an outline button? Default value FALSE.
#' @param size A character string giving the size of the input. Valid options are \code{normal},
#'   \code{sm} and \code{lg}. Defaults to \code{normal}
#'
#' @export
searchboxInput <- function(inputId, value = '', placeholder = NULL, button = NULL, icon = NULL,
                           color = 'primary', outline = FALSE, size = c('normal', 'sm', 'lg')) {

  outline <- ifelse(outline, 'outline-', '')
  size <- match.arg(size)

  if (is.null(button) & is.null(icon))
    button <- 'Search'
  if (is.null(button))
    button <- tags$i(class = paste0('oi oi-', icon))

  size <- list(
    form = ifelse(size %in% c('lg', 'sm'), paste0(' form-control-', size), ''),
    btn = ifelse(size %in% c('lg', 'sm'), paste0(' btn-', size), '')
  )

  value <- restoreInput(id = inputId, default = value)

  div(
    class = 'form-group shiny-input-container d-flex',
    tags$form(
      class = 'input-group form-inline searchbox px-1 my-2 w-100',
      tags$input(
        id = inputId, type = 'text', class = paste0('form-control', size$form),
        value = value, placeholder = placeholder, `aria-labelledby` = paste0(inputId, '-btn')),
      tags$div(class = 'input-group-append', tags$button(
        class = paste0('btn btn-', outline, color), type = 'button', button
      ))
    )
  )

}

#' Create a dropdown menu for inputs
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param label The text on the dropdown menu button.
#' @param choices List of values to select from.
#' @param selected The initially selected value.
#' @param multiple Is selection of multiple items allowed?
#' @param icon Optional icon shown before the label.
#' @param color A character string giving the color of the search button.
#' @param outline Should the button be an outline button? Default value \code{TRUE}.
#' @param size A character string giving the size of the input. Valid options are \code{normal},
#'   \code{sm} and \code{lg}. Defaults to \code{normal}
#' @param direction The direction of the menu. Default value \code{'up'}.
#'
#' @export
dropdownMenu <- function(inputId, label, choices, selected = NULL, multiple = FALSE, icon = NULL,
                         color = 'primary', outline = FALSE, size = c('normal', 'sm', 'lg'),
                         direction = c('down', 'right', 'up', 'left')) {

  selected <- restoreInput(id = inputId, default = selected)

  outline <- ifelse(outline, 'outline-', '')
  size <- match.arg(size)
  direction <- match.arg(direction)
  size <- ifelse(size %in% c('lg', 'sm'), paste0(' btn-', size), '')
  direction <- ifelse(direction != 'down', paste0('drop', direction), '')
  icon <- ifelse(is.null(icon), '', paste0('<i class="oi oi-', icon, '"></i> '))

  items <- lapply(choices, function(i) {
    class <- ifelse(i %in% selected, 'dropdown-item active', 'dropdown-item')
    a(class = class, href = '#', i)
  })

  div(
    class = paste('dropdown dropdownmenu', direction),
    id = inputId,
    tags$button(
      class = paste0('dropdown-toggle btn btn-', outline, color, size),
      type = 'button',
      `data-toggle` = 'dropdown',
      `data-multiple` = ifelse(multiple, 'true', 'false'),
      `aria-haspopup` = 'true',
      `aria-expanded` = 'false',
      list(HTML(icon), label)
    ),
    div(class = 'dropdown-menu', items)
  )

}

#' Switch input
#'
#' Create a switch input that can be used to specify logical values similar to a checkbox
#'
#' @inheritParams shiny::checkboxInput
#'
#' @return A switch input that can be added to a UI definition
#'
#' @seealso \code{\link[shiny]{checkboxInput}}
#'
#' @export
switchInput <- function(inputId, label, value = FALSE) {

  value <- restoreInput(id = inputId, default = value)

  inputTag <- tags$input(id = inputId, type = 'checkbox', class = 'custom-control-input')

  if (!is.null(value) && value)
    inputTag$attribs$checked = 'checked'

  div(
    class = 'custom-control custom-switch', inputTag,
    tags$label(class = 'custom-control-label', `for` = inputId, label))

}

#' Toggle button
#'
#' Creates a button that can be toggled on and off. Returns a \code{TRUE} value when the
#' button is pressed and a \code{FALSE} value when the button is not pressed. Defaults to
#' not pressed (not active).
#'
#' @param inputId The input slot that will be used to access the value.
#' @param label The contents of the button or link.
#' @param color Alternate Bootstrap 4 stylesheet.
#' @param outline Should the button be an outline button? Default value \code{TRUE}.
#' @param size The size of the button.
#' @param active Should the button be active on initalization? Default value \code{FALSE}.
#'
#' @export
toggleButton <- function(inputId, label, color = 'primary', outline = TRUE,
                         size = c('normal', 'sm', 'lg'), active = FALSE) {

  active <- restoreInput(id = inputId, default = active)

  outline <- ifelse(outline, 'outline-', '')
  color <- paste0('btn-', outline, color)
  size <- match.arg(size)
  size <- ifelse(size %in% c('lg', 'sm'), paste0('btn-', size), '')

  div(class = 'form-group shiny-input-container',
    tags$button(
      id = inputId,
      class = paste('toggle btn', size, color, ifelse(active, 'active', '')),
      `data-toggle` = 'button',
      `aria-pressed` = ifelse(active, 'true', 'false'),
      `autocomplete` = 'off',
      value = ifelse(active, 'true', 'false'),
      label
    )
  )

}

#' Update Toggle Button
#'
#' Change the state of the toggle button on the client.
#'
#' If both \code{value} and \code{change} is given, \code{value} is given priority.
#' If neither \code{value} nor \code{change} is given, \code{change} is assumed.
#'
#' @param session The \code{session} object passed to function given to \code{shinyServer}.
#' @param inputId The id of the input object.
#' @param value Optional. The new value of the button.
#' @param change Optional. If the current value should be changed.
#'
#' @export
updateToggleButton <- function(session, inputId, value = NULL, change = NULL) {
  if (is.null(value) && is.null(change)) change <- TRUE
  if (!is.null(value) && !is.null(change))
    change <- NULL
  message <- list(value = value, change = change)
  session$sendInputMessage(inputId, message)
}

#' Slicer Input
#'
#' Create a slicer -- a set of buttons that can act as a filter for a dataset.
#'
#' @inheritParams toggleButton
#' @param choices A list of choices to select from. Each choice will be displayed as a button.
#' @param selected A single value or a vector of values that will be initially selected.
#' @param multiple Is selection of multiple items allowed?
#'
#' @return A list control that can be added to a UI definition.
#'
#' @export
slicerInput <- function(inputId, label, choices, selected = NULL, color = 'primary',
                        outline = TRUE, multiple = FALSE) {

  # TODO: Add select all/deselect all option?
  # TODO: Add reset option?

  selected <- restoreInput(id = inputId, default = selected)

  if (is.null(selected) && !multiple)
    selected <- firstChoice(choices)
  else if (!multiple)
    selected <- firstChoice(selected)

  outline <- ifelse(outline, 'outline-', '')
  color <- paste0('btn-', outline, color)

  if (is.null(names(choices))) names(choices) <- choices

  html <- mapply(choices, names(choices), SIMPLIFY = FALSE, FUN = function(btn, label) {
    active <- ifelse(btn %in% selected, 'active', '')
    tags$button(
      class = paste('slicer-input btn btn-pill', color, active), `data-value` = btn,
      `aria-pressed` = ifelse(active == 'active', 'true', 'false'),
      htmlEscape(label))
  })

  divTag <- tags$div(
    id = inputId,
    class = 'input-group slicer mb-1',
    list(
      controlLabel(inputId, label),
      p(class = 'w-100 mb-1', html)
    )
  )

  if (multiple) divTag$attribs$multiple = 'multiple'

  divTag

}
#' Update slicer input
#' 
#' Change the state of the slicer input on the client.
#'
#' If both \code{value} and \code{change} is given, \code{value} is given priority.
#' If neither \code{value} nor \code{change} is given, \code{change} is assumed.
#' 
#' @inheritParams updateToggleButton
#' 
#' @export
updateSlicerInput <- function(session, inputId, value = NULL, change = NULL) {
  if (is.null(value) && is.null(change)) change <- TRUE
  if (!is.null(value) && !is.null(change))
    change <- NULL
  message <- list(value = value, change = change)
  session$sendInputMessage(inputId, message)
}
