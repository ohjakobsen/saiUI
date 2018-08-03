#' Dashboard page
#' 
#' Create a dashboard page that can be used with \code{\link{dashboardPanel}}s.
#' 
#' @param title The title for the page.
#' @param ... The UI elements of the page.
#' @param color A string indicating the color of the top navigation
#' @param brand A string indicating the brand for the page
#' @param windowTitle The title that should be displayed by the browser window.
#' 
#' @seealso \code{\link{dashboardPanel}}
#' 
#' @export
saiDashboard <- function(title, ..., color = 'dark', brand = title, windowTitle = title) {
  
  pageTitle <- title
  
  topNav <- tags$nav(
    class = paste0('navbar navbar-dark sticky-top bg-', color, ' flex-md-nowrap p-0'),
    div(id = 'sidebarHeader', class = 'col-sm-3 col-md-2 mr-0',
      a(class = 'navbar-brand', href = '#', brand),
      tags$button(
        class = 'navbar-toggler', `data-toggle` = 'collapse', `data-target` = '#mainnav',
        `aira-controls` = 'mainnav', `aria-expanded` = 'false', `aria-label` = 'Toggle navigation',
        HTML('<span class="navbar-toggler-icon"></span>')
      )
    )
  )
  
  tabs <- list(...)
  tabs[[1]]$attribs$class <- 'tab-pane fade show active'
  navItems <- buildDashboardNav(tabs)
  
  contentDiv <- div(class = 'col-md-9 ml-sm-auto col-lg-10 pt-3 px-4',
                    div(class = 'tab-content', tabs))
  
  deps <- list(htmlDependency(
    'dashboard', '0.3.0',
    c(file = system.file('www', package = 'saiUI')),
    stylesheet = c('css/dashboard.min.css')
  ))
  
  bs4Page(
    title = windowTitle,
    theme = NULL,
    deps = deps,
    topNav,
    div(class = 'container-fluid',
      div(class = 'row',
        navItems,
        contentDiv
      )
    )
  )
  
}

#' Dashboard panel
#' 
#' Create a dashboard panel.
#' 
#' @param title The title for the dashboard
#' @param ... The UI elements for the dashboard. Can be any Shiny input or output, or a
#'    \code{dashboardFilter}.
#' @param id The ID for the dashboard
#' @param value The value for the dashboard
#' @param icon A string giving the icon for the dashboard. Can be any icon from the OpenIconic
#'   library. See details.
#' 
#' @details This function creates a dashboard panel for outputting results from R functions.
#'   Icons can be:
#'   \itemize{
#'   \item{\code{dashboard}}
#'   \item{\code{bar-chart}}
#'   \item{\code{graph}}
#'   \item{\code{map-marker}}
#'   \item{\code{people}}
#'   \item{\code{pulse}}
#'   \item{\code{list}}
#'   \item{\code{bolt}}
#'   \item{\code{dollar}}
#'   \item{\code{cog}}
#'   }
#' 
#' @export
dashboardPanel <- function(title, ..., id = title, value = title, icon = 'dashboard') {
  
  # if (is.null(icon)) icon <- 'dashboard'
  
  divTag <- div(class = 'tab-pane fade',
                id = gsub('\\s', '', id),
                title = title,
                `role` = 'tabpanel',
                `aria-labelledby` = paste0(gsub('\\s', '', title), '-tab'),
                `data-value` = value,
                `data-icon-class` = icon,
                ...)
  
}

#' Dashboard filtering
#' 
#' @export
dashboardFilter <- function() {
  
  
  
}

# Build functions for dashboard layout
buildDashboardNav <- function(tabs) {
  
  # icons <- c('dashboard', 'bar-chart', 'list', 'pulse', 'people', 'graph', 'cog', 'clock', 'bolt', 'dollar')
  i <- 1
  
  tabs <- lapply(tabs, function(t) {
    
    icon <- HTML(paste0('<i class="oi oi-', t$attribs$`data-icon-class`, '"></i>'))
    class <- ifelse(i == 1, 'nav-link active', 'nav-link')
    selected <- ifelse(i == 1, 'true', 'false')
    i <<- i + 1
    # print(t$attribs)
    
    tags$li(class = 'nav-item',
      a(id = paste0(gsub('\\s', '', t$attribs$id), '-tab'), class = class,
        href = paste0('#', gsub('\\s', '', t$attribs$id)), `data-value` = t$attribs$`data-value`,
        `data-toggle` = 'tab',
        `role` = 'tab', `aria-selected` = selected, `aria-controls` = gsub('\\s', '', t$attribs$id),
        list(icon, t$attribs$title))
    )
    
  })
  
  # tags$nav(id = 'mainnav', class = 'col-md-2 d-none d-md-block bg-light sidebar',
  tags$nav(id = 'mainnav', class = 'col-md-2 d-md-block bg-light sidebar navbar-collapse collapse',
    div(id = 'pagenav', class = 'sidebar-sticky',
      tags$ul(class = 'nav flex-column', role = 'tablist',
        tabs
      )
    )
  )
  
}