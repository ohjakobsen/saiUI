#' Bootstrap Page
#'
#' @param ... A parameter
#' @param title The title for the page
#' @param theme A parameter
#' @param color A parameter
#'
#' @export
bs4Page <- function(..., title = NULL, theme = NULL) {

  attachDependencies(
    tagList(
      if (!is.null(title)) tags$head(tags$title(title)),
      if (!is.null(theme)) {
        tags$head(tags$link(rel="stylesheet", type="text/css", href = theme))
      },

      list(...)
    ),
    bs4Lib()
  )

}

#' Bootstrap Libraries
#'
#' This function returns a set of web dependencies necessary for using Bootstrap
#' components in a web page
#'
#' @export
bs4Lib <- function(theme = NULL) {
  htmlDependency('bootstrap', '4.0.0',
    c(file = system.file('www', package = 'saiUI')),
    script = c('bs4/js/bootstrap.min.js', 'js/saiUI.min.js'),
    stylesheet = if (is.null(theme)) 'bs4/css/bootstrap.min.css',
    meta = list(viewport = "width=device-width, initial-scale=1")
  )
}

#' SAI page element
#'
#' This functions builds the actual HTML page.
#'
#' @export
saiPage <- function(title,
                    ...,
                    id = NULL,
                    selected = NULL,
                    position = c(),
                    header = NULL,
                    footer = NULL,
                    theme = NULL,
                    color = 'primary',
                    windowTitle = title) {

  pageTitle <- title

  tabs <- list(...)
  tabs[[1]]$attribs$class <- 'tab-pane fade show active'
  # lapply(tabs, function(t) print(t$attribs))

  class = paste0('navbar navbar-expand-lg navbar-dark bg-', color)

  navItems <- buildNavbar(pageTitle, tabs, color)

  # Build the page
  bs4Page(
    title = windowTitle,
    theme = theme,
    tags$nav(class = class, navItems),
    tags$div(class = 'tab-content', tabs)
  )

}

#' @export
saiMenu <- function(..., width = 4) {

  div(class=paste0('col-sm-', width, ' bg-light'),
      tags$form(class='p-2',
                ...)
      )

}

#' @export
saiMain <- function(..., width = 8) {

  div(class=paste0('col-sm-', width),
      tags$section(class = 'p-2', ...)
      )

}

buildNavbar <- function(title, tabs, color = 'primary') {

  i <- 1
  tabs <- lapply(tabs, function(t) {

    class <- ifelse(i == 1, 'nav-link active', 'nav-link')
    class <- paste0(class, ' btn btn-', color)
    selected <- ifelse(i == 1, 'true', 'false')
    i <<- i + 1

    list(
      tags$li(class='nav-item px-1',
        a(id = paste0(gsub('\\s', '', t$attribs$title), '-tab'), class = class,
          href = paste0('#', gsub('\\s', '', t$attribs$title)), `data-toggle` = 'pill', t$attribs$title,
          `role` = 'tab', `aria-selected` = selected, `aria-controls` = gsub('\\s', '', t$attribs$title))
      )
    )

  })

  list(
    tags$a(class='navbar-brand', href='#', title),
    HTML('<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#shinyNavbar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
         </button>'),
    tags$div(id = 'shinyNavbar', class='collapse navbar-collapse',
      tags$ul(class='nav nav-pills navbar-nav mr-auto', `role` = 'tablist',
        tabs
      )
    )
  )

}

#' Overrides default Shiny `tabPanel`
#'
#' @export
tabPanel <- function(title, ..., value = title, icon = NULL) {
  divTag <- div(class='tab-pane fade',
                id = gsub('\\s', '', title),
                title=title,
                `role` = 'tabpanel',
                `aria-labelledby` = paste0(gsub('\\s', '', title), '-tab'),
                `data-value`=value,
                `data-icon-class` = NULL,
                div(class = 'row', ...))
}
