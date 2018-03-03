#' Bootstrap Page
#' @export
bs4Page <- function(..., title = NULL, theme = NULL, color = 'primary') {

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
    c(file = system.file('www/bs4', package = 'saiUI')),
    script = c('js/bootstrap.min.js'),
    stylesheet = if (is.null(theme)) 'css/bootstrap.min.css',
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
                    inverse = FALSE,
                    fluid = TRUE,
                    theme = NULL,
                    windowTitle = title) {

  pageTitle <- title

  tabs <- list(...)

  navItems <- buildNavbar(pageTitle)

  # Build the page
  bs4Page(
    title = windowTitle,
    theme = theme,
    tags$nav(class='navbar navbar-expand-lg navbar-dark bg-primary', navItems),
    tags$div(class='content', ...)
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

buildNavbar <- function(title) {

  list(
    tags$a(class='navbar-brand', href='#', title),
    HTML('<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
         </button>'),
    tags$div(class='collapse navbar-collapse',
      tags$ul(class='navbar-nav mr-auto',
        tags$li(
          class='nav-item',
          a(class = 'nav-link', href = '#', 'Tab')
        )
      )
    )
  )

}

#' Overrides default Shiny `tabPanel`
#'
#' @export
tabPanel <- function(title, ..., value = title, icon = NULL) {
  divTag <- div(class='row',
                title=title,
                `data-value`=value,
                `data-icon-class` = NULL,
                ...)
}
