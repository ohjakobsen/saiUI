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
  
  classes <- paste0('alert alert-', color)
  if (dismissable) classes <- paste(classes, 'alert-dismissible fade show')
  
  if (!is.null(icon)) {
    icon <- tags$i(class = paste0('oi oi-', icon))
    classes <- paste(classes, 'alert-icon')
  }
  
  divTag <- div(class = classes, role = 'alert', list(icon, ...))
  
  if (dismissable)
    divTag <- tagAppendChild(divTag, tags$button(
      class = 'close', type = 'button', `data-dismiss` = 'alert', `aria-label` = 'Close',
      tags$span(`aria-hidden` = TRUE, HTML('&times;'))
    ))
  
  divTag
  
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
