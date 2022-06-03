#' Create alert in UI
#' 
#' Create a Bootstrap alert box that optionally can be dismissed by the user.
#' 
#' @param ... One or more HTML elements to show in the alert
#' @param color The color of the alert
#' @param icon An optional \code{\link[=createIcon]{icon}} to appear next to the text
#' @param dismissable If \code{TRUE} the user can dismiss the alert. Defaults to
#'   \code{FALSE}.
#'   
#' @details
#' This creates a Bootstrap 4 type alert that can be shown in the UI. The alert can
#' optionally be dismissed by the user, by setting the argument \code{dismissable} to
#' \code{TRUE}.
#' 
#' Alerts can be placed anywhere in the UI. They are useful for highlighting important
#' information to the user. If you want to send a message to the user,
#' \code{\link[=sendToast]{toast notifications}} might be a better alternative.
#' 
#' @examples
#' bs4Alert('This is important information', color = 'warning', icon = 'warning')
#' 
#' @seealso \code{\link{sendToast}}
#' 
#' @export
bs4Alert <- function(..., color = 'primary', icon = NULL, dismissable = FALSE) {
  
  cls <- sprintf('alert alert-%s', color)
  if (dismissable) cls <- paste(cls, 'alert-dismissible fade show')
  
  if (!is.null(icon)) {
    icon <- createIcon(icon)
    cls <- sprintf('%s alert-icon', cls)
  }
  
  divTag <- div(class = cls, role = 'alert', list(icon, ...))
  
  if (dismissable)
    divTag <- tagAppendChild(divTag, tags$button(
      class = 'close', type = 'button', `data-dismiss` = 'alert', `aria-label` = 'Close',
      tags$span(`aria-hidden` = TRUE, HTML('&times;'))
    ))
  
  divTag
  
}

#' Create a modal button
#' 
#' Create a button that will dismiss a modal dialog.
#' 
#' @inheritParams actionButton
#' 
#' @seealso \code{\link{bs4Modal}}
#' 
#' @export
bs4ModalButton <- function(
  label = 'Close', icon = NULL, color = 'secondary', size = c('normal', 'sm', 'lg'))
{
  
  icon <- if (!is.null(icon)) createIcon(icon) else NULL
  size <- match.arg(size)
  size <- switch(size, normal = NULL, sprintf('btn-%s', size))
  cls <- paste(c('btn', size, sprintf('btn-%s', color)), collapse = ' ')
  
  tags$button(
    type = 'button', class = cls,
    `data-dismiss` = 'modal', icon, label)
  
}

#' @rdname bs4ModalButton
#' @export
modalButton <- bs4ModalButton

#' Create a modal dialog
#' 
#' @param ... UI elements for the body of the modal dialog box.
#' @param title An optional title for the modal.
#' @param valign Boolean. If \code{TRUE} the modal is vertically centered
#' @param size The size of the modal. One of \code{s}, \code{m} (default), \code{l} or \code{xl}
#' @param footer UI for the footer of the modal
#' @param easyClose Boolean. If \code{TRUE} the modal can be dismissed by clicking outside
#'   the dialog box
#' @param fade Boolean. If \code{TRUE} the modal will fade out when closed
#' 
#' @export
bs4Modal <- function(
  ..., title = NULL, valign = FALSE, size = 'm', footer = bs4ModalButton(),
  easyClose = FALSE, fade = TRUE)
{
  
  size <- match.arg(size, c('m', 's', 'l', 'xl'))
  cls <- if (fade) 'modal fade' else 'modal'
  
  if (!is.null(title))
    headerTag <- div(class = 'modal-header', h5(class = 'modal-title', title))
  else
    headerTag <- NULL
  
  footerTag <- div(class = 'modal-footer', footer)
  
  divTag <- div(
    id = 'shiny-modal', class = cls, role ='dialog', tabindex = '-1',
    div(
      class = 'modal-dialog modal-dialog-scrollable',
      class = switch(size, s = 'modal-s', m = 'modal-m', l = 'modal-l', xl = 'modal-xl', 'modal-m'),
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

#' @rdname bs4Modal
#' @export
modalDialog <- bs4Modal

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
bs4Dropdown <- function(
  title, ..., color = 'primary', outline = FALSE, size = c('normal', 'sm', 'lg'),
  width = 400, direction = c('down', 'right', 'up', 'left'), autoclose = TRUE)
{
  
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
  
  cls <- sprintf('embed-responsive embed-responsive-%sby%s', ratio[1], ratio[2])
  type <- match.arg(type)
  
  embedTag <- switch(
    type,
    'iframe' = tags$iframe(class = 'embed-responsive-item', src = URLencode(src)),
    'video' = tags$video(class = 'embed-responsive-item', src = URLencode(src)),
    'embed' = tags$embed(class = 'embed-responsive-item', src = URLencode(src))
  )
  
  divTag <- div(class = cls, embedTag)
  
  divTag
  
}

#' Create an icon tag
#' 
#' Create an icon for use within a page or UI element, such as inside a button. This
#' function extends and replaces the \code{\link[shiny]{icon}} function in \code{shiny}.
#' 
#' @param icon The icon name. Must be a valid icon name from Font Awesome Free or
#'   Open Iconic. Prefixes such as \code{fa-} and \code{oi-} are not needed.
#' @param class Addictional classes to cutomize the style of the icon
#' @param lib Icon library to use. See details.
#' 
#' @details 
#' \code{shiny} supports the Font Awesome Free library. In addition, \code{saiUI} supports
#' the Open Iconic library. This is also the default library. See \code{\link[shiny]{icon}}
#' for more details on using Font Awesome Free. Note that Glyphicons has been removed
#' from Bootstrap 4. Since saiUI replaces all Bootstrap 3 resources, Glyphicons is
#' not available as the relevant CSS files will not be loaded.
#' 
#' UI elements that support icons, will use the default library. You can override this
#' by using \code{createIcon} instead of a character vector, and specifying the
#' \code{lib} argument.
#' 
#' @examples 
#' \dontrun{
#' # Create an action button with the default icon library
#' actionButton("button", "A button", icon = "info")
#' # Specify a custom library by using createIcon
#' actionButton("button", "A button", icon = createIcon("info", lib = "font-awesome"))
#' }
#' 
#' @export
createIcon <- function(icon, class = NULL, lib = 'oi') {
  
  if (inherits(icon, 'shiny.tag') && icon$name == 'i') return(icon)
  
  if (lib == 'oi') {
    iconTag <- tags$i()
    iconTag$attribs$class <- sprintf('oi oi-%s', icon)
    htmlDependencies(iconTag) <- htmlDependency(
      'openiconic', '1.1.0', 'www/oi', package = 'saiUI',
      stylesheet = 'css/open-iconic-bootstrap.min.css'
    )
  } else if (lib == 'font-awesome') {
    iconTag <- shiny::icon(icon, class = class, lib = lib)
  } else if (lib == 'glyphicon') {
    warning(lib, ' has been removed in Bootstrap 4')
  } else {
    stop(lib, ' is an unknown icon library')
  }
  
  htmltools::browsable(iconTag)
  
}
