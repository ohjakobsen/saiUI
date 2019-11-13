#' Create alert in UI
#' 
#' Create a Bootstrap alert box that optionally can be dismissed by the user.
#' 
#' @param ... One or more HTML elements to show in the alert
#' @param color The color of the alert
#' @param icon Name of an icon from the Open Iconic library that should be shown before the text
#' @param dismissable Should the user be allowed to dismiss the alert
#' 
#' @export
bs4Alert <- function(..., color = 'primary', icon = NULL, dismissable = FALSE) {
  
  classes <- sprintf('alert alert-%s', color)
  if (dismissable) classes <- paste(classes, 'alert-dismissible fade show')
  
  if (!is.null(icon)) {
    icon <- tags$i(class = sprintf('oi oi-%s', icon))
    classes <- sprintf('%s alert-icon', classes)
  }
  
  divTag <- div(class = classes, role = 'alert', list(icon, ...))
  
  if (dismissable)
    divTag <- tagAppendChild(divTag, tags$button(
      class = 'close', type = 'button', `data-dismiss` = 'alert', `aria-label` = 'Close',
      tags$span(`aria-hidden` = TRUE, HTML('&times;'))
    ))
  
  divTag
  
}

#' Add modal button
#' 
#' @param text The text of the close button.
#' 
#' @export
bs4ModalButton <- function(text = 'Close') {
  
  tags$button(type = 'button', class = 'btn btn-secondary', `data-dismiss` = 'modal', text)
  
}

#' Create a modal dialog
#' 
#' @param ... UI elements for the body of the modal dialog box.
#' @param title An optional title for the modal.
#' @param valign Boolean. If \code{TRUE} the modal is vertically centered
#' @param size The size of the modal. One of \code{s}, \code{m} (default), \code{l} or \code{xl}
#' @param footer UI for the footer of the modal
#' @param easyClose Boolean. If \code{TRUE} the modal can be dismissed by clicking outside
#'   the dialog box
#' 
#' @export
bs4Modal <- function(..., title = NULL, valign = FALSE, size = c('m', 's', 'l', 'xl'),
                     footer = bs4ModalButton(), easyClose = FALSE) {
  
  size <- match.arg(size)
  cls <- 'modal fade'
  
  if (!is.null(title))
    headerTag <- div(class = 'modal-header', h5(class = 'modal-title', title))
  else
    headerTag <- NULL
  
  footerTag <- div(class = 'modal-footer', footer)
  
  divTag <- div(
    id = 'shiny-modal', class = cls, role ='dialog', tabindex = '-1',
    div(
      class = 'modal-dialog modal-dialog-scrollable',
      class = switch(size, s = 'modal-s', m = 'modal-m', l = 'modal-l', xl = 'modal-xl'),
      role = 'document',
      div(
        class = 'modal-content',
        headerTag,
        div(class = 'modal-body', ...),
        footerTag)
    )
  )
  
  list(divTag, tags$script("$('#shiny-modal').modal().focus();"))
  
}

#' Create Bootstrap dropdown button with custom UI
#' 
#' @param title The name of the dropdown button
#' @param ... UI elements in the dropdown
#' @param color The color of the dropdown button
#' @param outline If \code{TRUE} display an outline button
#' @param size A character string giving the size of the input. Valid options are \code{normal},
#'   \code{sm} and \code{lg}. Defaults to \code{normal}
#' @param width The width of the dropdown in pixels
#' @param direction The direction of the dropdown Default value \code{'down'}.
#' @param autoclose If \code{TRUE} the dropdown will close when the user clicks inside it
#' 
#' @export
bs4Dropdown <- function(title, ..., color = 'primary', outline = FALSE,
                        size = c('normal', 'sm', 'lg'), width = 400,
                        direction = c('down', 'right', 'up', 'left'),
                        autoclose = TRUE) {
  
  outline <- if (outline) 'outline-' else ''
  size <- match.arg(size)
  size <- switch(size, 'normal' = '', sprintf('btn-%s', size))
  direction <- match.arg(direction)
  direction <- switch(direction, down = '', sprintf('drop%s', direction))
  
  div(
    class = 'btn-group', class = direction,
    tags$button(
      class = sprintf('dropdown-toggle btn btn-%s%s', outline, color), class = size,
      type = 'button', `data-toggle` = 'dropdown', `aria-haspopup` = 'true',
      `aria-expanded` = 'false', title
    ),
    div(
      class = 'dropdown-menu p-3',
      `data-autoclose` = if (autoclose) 'true' else 'false',
      style = sprintf('width: %spx; max-width: 90vw;', width),
      div(...))
  )
  
}

#' Create responsive embed
#' 
#' Embed content from and external source and make the embed responsive.
#' 
#' @param src The URL to the source that will be embedded
#' @param type The type of HTML tag that should be used (usually an `iframe`)
#' @param ratio A vector of lenght 2 with the aspect ratio for the embedded content.
#'   See details
#' 
#' @details 
#' Supported aspect ratios are 16 by 9 (default), 4 by 3, 21 by 9 and 1 by 1.
#' 
#' @importFrom utils URLencode
#' 
#' @export
bs4Embed <- function(src, type = c('iframe', 'video', 'embed'), ratio = c(16, 9)) {
  
  classes <- sprintf('embed-responsive embed-responsive-%sby%s', ratio[1], ratio[2])
  type <- match.arg(type)
  
  embedTag <- switch(
    type,
    'iframe' = tags$iframe(class = 'embed-responsive-item', src = URLencode(src)),
    'video' = tags$video(class = 'embed-responsive-item', src = URLencode(src)),
    'embed' = tags$embed(class = 'embed-responsive-item', src = URLencode(src))
  )
  
  divTag <- div(class = classes, embedTag)
  
  divTag
  
}
