#' @importFrom stats runif
NULL

#' Add a container for sending toast notifications
#' 
#' Manually insert a toast container. For \code{\link{saiPage}} and \code{\link{saiDashboard}},
#' use the \code{notifications} argument instead. If you want to override the positioning
#' of toast notifications, you need to set this argument to \code{FALSE}.
#' 
#' @export
toastWrapper <- function() {
  div(
    style = 'position: fixed; width: 100%; height: auto; z-index: 999;',
    div(id = 'toast-container')
  )
}

#' Send toast notification to the UI
#'
#' Sends a toast notification to the user. Requires that a container for toast
#' notifications has been enabled. See details
#'
#' @param title A character vector with the title of the notification
#' @param message A character vector or a tag object with the content of the notification
#' @param session The Shiny session object
#' @param autohide If \code{TRUE}, the notification will automatically be hidden after
#'   a set delay
#' @param delay A numeric value giving the delay in milliseconds before hiding the toast
#'
#' @export
sendToast <- function(
  title, message, session = shiny::getDefaultReactiveDomain(), autohide = TRUE,
  delay = 5000)
{

  id <- sprintf('toast-%s', floor(runif(1, 10000, 99999)))
  autohide <- if (autohide) 'true' else 'false'
  delay <- as.integer(delay)

  session$sendCustomMessage('createToast', list(title, message, id, autohide, delay))

}
