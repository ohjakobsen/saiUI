#' Create an action button
#'
#' @inherit shiny::actionButton
#'
#' @param color Alternate Bootstrap 4 stylesheet.
#' @param outline If \code{TRUE}, background color will be removed from the button.
#'   Defaults to \code{FALSE}.
#' @param class Additional CSS classes to add to the button
#' @param size The size of the button. Use \code{sm} for small and \code{lg} for
#'   large buttons.
#'
#' @export
actionButton <- function(
  inputId, label, color = 'primary', outline = FALSE, icon = NULL, class = NULL,
  width = NULL, size = c('normal', 'sm', 'lg'), ...)
{

  value <- restoreInput(id = inputId, default = NULL)
  color <- sprintf('btn-%s%s', if (outline) 'outline-' else '', color)
  size <- match.arg(size)
  size <- switch(size, normal = NULL, sprintf('btn-%s', size))
  classes <- paste(c('shiny-download-link btn', size, color, class), collapse = ' ')
  
  if (!is.null(icon)) icon <- createIcon(icon)

  tags$button(
    id = inputId, type = 'button', class = classes, `data-val` = value,
    list(icon, label), ...
  )
}

#' Create a download button or link
#'
#' @inherit shiny::downloadButton
#' @inheritParams actionButton
#'
#' @export
downloadButton <- function(
  outputId, label = 'Download', color = 'primary', outline = FALSE, class = NULL,
  size = c('normal', 'sm', 'lg'), ...)
{

  color <- sprintf('btn-%s%s', if (outline) 'outline-' else '', color)
  size <- match.arg(size)
  size <- switch(size, normal = NULL, sprintf('btn-%s', size))
  classes <- paste(c('shiny-download-link btn', size, color, class), collapse = ' ')
  icon <- createIcon('cloud-download', 'oi')
  
  aTag <- tags$a(
    id = outputId, role = 'button', class = classes, href = '', target = '_blank',
    download = NA, tagList(icon, label), ...)
  
  aTag
  
}

#' File Upload Control
#'
#' Create a file upload control that can be used to upload one or more files. This function
#' is masked from \code{shiny}.
#'
#' @inherit shiny::fileInput
#'
#' @export
fileInput <- function(
  inputId, label, multiple = FALSE, accept = NULL, width = NULL, buttonLabel = NULL,
  placeholder = 'Choose file')
{

  inputTag <- tags$input(
    id = inputId,
    class = 'custom-file-input',
    name = inputId,
    type = 'file'
  )

  if (multiple) inputTag$attribs$multiple <- 'multiple'
  if (length(accept) > 0L)
    inputTag$attribs$accept <- paste(accept, collapse = ',')

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
      id = paste(inputId, '_progress', sep = ''),
      class = 'progress progress-striped active shiny-file-input-progress',
      tags$div(class = 'progress-bar')
    )
  )

}

#' Create a searchbox input
#' 
#' Create an input control for text that behaves as a search field.
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
#' @param searchAsYouType If \code{TRUE}, the value will be continously updated to
#'   Shiny. See details.
#'
#' @details 
#' If \code{searchAsYouType} is set to \code{TRUE}, values will be sent to Shiny as
#' the user types (with a slight delay to account for continous typing).If the input
#' invalidates an expensive reactive function on the server, \code{searchAsYouType}
#' should be set to \code{FALSE}. This is also the default behaviour. When set to
#' \code{FALSE}, the value will not be updated before the user clicks on the button or
#' hits the enter key.
#'
#' @export
searchboxInput <- function(
  inputId, value = '', placeholder = NULL, button = NULL, icon = NULL,
  color = 'primary', outline = FALSE, size = c('normal', 'sm', 'lg'),
  searchAsYouType = FALSE)
{

  outline <- if (outline) 'outline-' else ''
  size <- match.arg(size)

  if (is.null(button) & is.null(icon))
    button <- 'Search'
  if (is.null(button))
    button <- createIcon(icon)

  size <- list(
    form = switch(size, 'lg' = 'form-control-lg', 'sm' = 'form-control-sm', ''),
    clear = switch(size, 'lg' = 'form-clear-lg', 'sm' = 'form-clear-sm', ''),
    btn = switch(size, 'lg' = 'btn-lg', 'sm' = 'btn-sm', '')
  )

  value <- restoreInput(id = inputId, default = value)
  
  inputTag <- tags$input(
    id = inputId, type = 'text', class = 'form-control', class = size$form,
    value = value, placeholder = placeholder, `aria-labelledby` = sprintf('%s-btn', inputId)
  )
  
  if (searchAsYouType) inputTag <- tagAppendAttributes(inputTag, 'data-sayt' = 'true')

  div(
    class = 'form-group shiny-input-container d-flex',
    tags$form(
      class = 'input-group form-inline searchbox my-2 w-100',
      inputTag,
      tags$span(class = 'form-clear d-none', class = size$clear),
      tags$div(
        class = 'input-group-append searchbox-button',
        tags$button(
          class = sprintf('btn btn-%s%s', outline, color), class = size$btn,
          type = 'button', button))
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
#' @param direction The direction of the menu. Default value \code{'down'}.
#'
#' @export
dropdownMenu <- function(
  inputId, label, choices, selected = NULL, multiple = FALSE, icon = NULL,
  color = 'primary', outline = FALSE, size = c('normal', 'sm', 'lg'),
  direction = c('down', 'right', 'up', 'left'))
{

  selected <- restoreInput(id = inputId, default = selected)

  outline <- if (outline) 'outline-' else ''
  size <- match.arg(size)
  size <- switch(size, 'normal' = '', sprintf('btn-%s', size))
  direction <- match.arg(direction)
  direction <- switch(direction, down = '', sprintf('drop%s', direction))

  items <- lapply(choices, function(i) {
    class <- ifelse(i %in% selected, 'dropdown-item active', 'dropdown-item')
    a(class = class, role = 'button', tabindex = '0', i)
  })

  div(
    class = 'dropdown dropdownmenu', class = direction,
    id = inputId,
    tags$button(
      class = sprintf('dropdown-toggle btn btn-%s%s %s', outline, color, size),
      type = 'button',
      `data-toggle` = 'dropdown',
      `data-multiple` = ifelse(multiple, 'true', 'false'),
      `aria-haspopup` = 'true',
      `aria-expanded` = 'false',
      if (!is.null(icon)) createIcon(icon),
      label
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
toggleButton <- function(
  inputId, label, color = 'primary', outline = TRUE,
  size = c('normal', 'sm', 'lg'), active = FALSE)
{

  active <- restoreInput(id = inputId, default = active)
  size <- match.arg(size)
  
  outline <- if (outline) 'outline-' else ''
  color <- sprintf('btn-%s%s', outline, color)
  size <- switch(size, normal = '', sprintf('btn-%s', size))
  active <- if (active) 'active' else ''

  div(class = 'form-group shiny-input-container',
    tags$button(
      id = inputId,
      class = sprintf('toggle btn %s%s', color, size),
      class = active,
      `data-toggle` = 'button',
      `aria-pressed` = switch(active, active = 'true', 'false'),
      `autocomplete` = 'off',
      `data-value` = switch(active, active = 'true', 'false'),
      label
    )
  )

}

#' Update Toggle Button
#'
#' Change the state of the toggle button on the client.
#'
#' @param session The \code{session} object passed to function given to \code{shinyServer}.
#' @param inputId The id of the input object.
#' @param value Optional. The new value of the button.
#' @param change Optional. If the current value should be changed.
#' 
#' @details 
#' If both \code{value} and \code{change} is given, \code{value} is given priority.
#' If neither \code{value} nor \code{change} is given, \code{change} is assumed.
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
slicerInput <- function(
  inputId, label, choices, selected = NULL, color = 'primary', outline = TRUE,
  multiple = FALSE)
{
 
  selected <- restoreInput(id = inputId, default = selected)

  if (is.null(selected) && !multiple)
    selected <- firstChoice(choices)
  else if (!multiple)
    selected <- firstChoice(selected)

  color <- sprintf('btn-%s%s', if (outline) 'outline-' else '', color)

  if (is.null(names(choices))) names(choices) <- choices

  html <- mapply(choices, names(choices), SIMPLIFY = FALSE, FUN = function(btn, label) {
    active <- if (btn %in% selected) 'active' else ''
    tags$button(
      class = paste('slicer-input btn btn-pill', color, active), `data-value` = btn,
      `aria-pressed` = switch(active, active = 'true', 'false'),
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
