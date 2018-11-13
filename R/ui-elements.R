#' Create alert in UI
#' 
#' Create a Bootstrap alert box that optionally can be dismissed by the user.
#' 
#' @param ... One or more HTML elements to show in the alert
#' @param color The color of the alert
#' @param dismissable Should the user be allowed to dismiss the alert
#' 
#' @export
bs4Alert <- function(..., color = 'primary', dismissable = FALSE) {
  
  classes <- paste0('alert alert-', color)
  
  divTag <- div(class = classes, ...)
  
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
#' @param type The type of source (usually an `iframe`)
#' @param ratio A vector of lenght 2 with the aspect ratio for the embedded content.
#'   See details
#' 
#' @details 
#' Supported aspect ratios are 16 by 9 (default), 4 by 3, 21 by 9 and 1 by 1.
#' 
#' @export
bs4Embed <- function(src, type = c('iframe', 'video'), ratio = c(16, 9)) {
  
  classes <- paste0('embed-responsive embed-responsive-', ratio[1],'by', ratio[2])
  
  divTag <- div(
    class = classes,
    tags$iframe(
      class = 'embed-responsive-item',
      src = URLencode(src)
    )
  )
  
  divTag
  
}
