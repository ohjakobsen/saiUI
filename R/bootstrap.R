#' @import htmltools
#' @importFrom shiny restoreInput icon
#' @importFrom utils packageVersion
NULL

#' Bootstrap Page
#'
#' @param ... The UI elements of the page.
#' @param title The title for the page.
#' @param theme A character string or a \code{\link[htmltools]{htmlDependency}}-object
#'   with an alternate Bootstrap 4 stylesheet.
#' @param deps Additional dependencies to add to the page.
#' @param lang The language of the page that is added to the top level \code{html} element.
#' @param dir Indicate the directionality of text in the \code{html} page
#'
#' @export
bs4Page <- function(
  ..., title = NULL, theme = NULL, deps = NULL, lang = 'en', dir = 'ltr')
{
  
  if (!is.null(deps)) {
    if (is.list(deps) && !all(sapply(deps, inherits, 'html_dependency')))
      stop('You can only include objects of type html_dependency in the deps argument!')
    else if (is.list(deps) && all(sapply(deps, inherits, 'html_dependency')))
      deps <- deps
    else if (inherits(deps, 'html_dependency'))
      deps <- list(deps)
    else
      deps <- NULL
  }
  
  if (!is.null(theme)) {
    if (inherits(theme, 'html_dependency') && !is.null(deps))
      deps <- c(deps, list(theme))
    else if (inherits(theme, 'html_dependency') && is.null(deps))
      deps <- list(theme)
    else if (is.character(theme) && nzchar(theme))
      theme <- tags$link(rel="stylesheet", type="text/css", href = theme)
    else
      theme <- NULL
  }
  
  # Render the html template
  html <- htmlTemplate(
    system.file('templates', 'default.html', package = 'saiUI'),
    theme = theme,
    body = tagList(
      if (!is.null(title)) tags$head(tags$title(title)),
      list(...)
    ), lang = sprintf('lang="%s" dir="%s"', lang, dir)
  )
  
  attachDependencies(
    html,
    bs4Lib(is.null(theme), deps)
  )

}

#' Bootstrap Libraries
#'
#' This function returns a set of web dependencies necessary for using Bootstrap
#' components in a web page
#'
#' @param theme If \code{TRUE} the default Bootstrap theme will be added.
#' @param deps Additional dependencies to add to the page.
#'
#' @export
bs4Lib <- function(theme = TRUE, deps = NULL) {
  if (!is.null(deps) && !is.list(deps))
    stop('You need to provide a list of dependencies with the deps argument!')
  
  libs <- list(
    htmlDependency('bootstrap', '4.4.1',
      c(file = system.file('www/bs4', package = 'saiUI')),
      script = c('js/popper.min.js', 'js/bootstrap.min.js'),
      stylesheet = if (theme) 'css/bootstrap.min.css',
      meta = list(viewport = 'width=device-width, initial-scale=1, shrink-to-fit=no')
    ),
    htmlDependency('saiUI', packageVersion('saiUI'),
      c(file = system.file('www', package = 'saiUI')),
      script = c('js/saiUI.min.js', 'js/bindings.min.js'),
      stylesheet = 'css/saiUI.min.css'
    )
  )
  if (!is.null(deps)) libs <- c(libs, deps)
  libs
}

#' @rdname bs4Lib
#' @export
saiLib <- bs4Lib

#' Create a simple Bootstrap page
#' 
#' @inheritParams bs4Page
#' 
#' @export
singlePage <- function(title, ..., theme = NULL, lang = 'en') {
  
  bs4Page(
    div(class = 'container-fluid', ...),
    title = title, theme = theme, lang = lang)
  
}

#' SAI page element
#'
#' This functions builds the actual HTML page.
#'
#' @inheritParams bs4Page
#' @param title The title to display in the navbar.
#' @param ... The UI elements of the page. Top level elements should be \code{\link{tabPanel}}.
#' @param id The page ID
#' @param selected The tab that is initially selected
#' @param header Tag or list of tags to display as a common header above all tabPanels.
#' @param footer Tag or list of tags to display as a common footer below all tabPanels.
#' @param color Color for the navbar. Supports all Bootstrap 4 colors.
#' @param notifications If \code{TRUE} (default), toast notifications are enabled
#' @param windowTitle The title that should be displayed by the browser window.
#'
#' @export
saiPage <- function(
  title, ..., id = NULL, selected = NULL, header = NULL, footer = NULL, theme = NULL,
  color = 'primary', notifications = TRUE, windowTitle = title, lang = 'en', dir = 'ltr')
{

  pageTitle <- title
  tabs <- list(...)
  
  if (!is.null(id))
    selected <- restoreInput(id = id, default = selected)
  
  if (!is.null(selected))
    tabselect <- which(sapply(tabs, function(t) t$attribs$id) == selected)
  else
    tabselect <- 1
  
  tabClass <- tabs[[tabselect]]$attribs$class
  tabs[[tabselect]]$attribs$class <- sprintf('%s show active', tabClass)
  
  class <- sprintf(
    'mainnav navpage navbar navbar-expand-lg %s bg-%s',
    if (color == 'light') 'navbar-light' else 'navbar-dark',
    color
  )

  navItems <- buildNavbar(pageTitle, tabs, tabselect, color)

  pageTabs <- div(class = 'tab-content', id = id, role = 'main', tabs)
  
  pageBody <- div(class = 'page-container')
  pageBody <- tagAppendChild(pageBody, tags$nav(class = class, id = id, navItems))
  if (notifications) pageBody <- tagAppendChild(pageBody, toastWrapper())
  if (!is.null(header)) pageBody <- tagAppendChild(pageBody, div(class = 'header', header))
  pageBody <- tagAppendChild(pageBody, pageTabs)
  if (!is.null(footer)) pageBody <- tagAppendChild(pageBody, div(class = 'footer', footer))
  
  # Build the page
  bs4Page(
    title = windowTitle,
    theme = theme,
    lang = lang,
    dir = dir,
    pageBody
  )

}

#' SAI menu
#'
#' Create a sidebar panel containing input controls.
#'
#' @param ... UI elements to include on the sidebar
#' @param width The width of the sidebar. For fluid layouts this is out of 12 total units;
#'   for fixed layouts it is out of whatever the width of the sidebar's parent column is.
#' @param color Background color for the sidebar.
#'
#' @export
saiMenu <- function(..., width = 4, color = 'light') {
  
  text_color <- if (!(color %in% c('light', 'white', 'info'))) 'text-white' else ''

  div(class = sprintf('col-md-%s bg-%s %s pt-2', width, color, text_color),
      tags$form(...)
  )

}

#' Main content
#'
#' Create a main panel containing output elements
#'
#' @param ... Output elements to include in the main panel
#' @param width The width of the main panel. For fluid layouts this is out of 12 total units;
#'   for fixed layouts it is out of whatever the width of the sidebar's parent column is.
#'
#' @export
saiMain <- function(..., width = 8) {

  div(class = sprintf('col-md-%s pt-2', width),
      tags$section(...))

}

#' Add content to page header
#' 
#' Add a text message above the content area on \code{\link{saiPage}}
#' 
#' @param ... The text to include in the header
#' @param color The background color for the text. Must be a valid Bootstrap 4 color
#' 
#' @export
headerContent <- function(..., color = 'primary') {
  
  text_color <- if (!(color %in% c('light', 'white', 'info'))) 'text-white' else ''
  color <- sprintf('bg-%s', color)
  
  div(class = paste(color, text_color, 'clearfix'),
      p(class = 'p-2 m-0', ...))
  
}

#' Add content to page footer
#' 
#' Add a text message below the content area on \code{\link{saiPage}}
#' 
#' @param ... The text to include in the footer
#' @param color The background color for the text. Must be a valid Bootstrap 4 color
#' @param center If \code{TRUE} the text will be centered
#' @param small If \code{TRUE} the text will be smaller than the body text
#' 
#' @export
footerContent <- function(..., color = 'light', center = TRUE, small = FALSE) {
  
  text_color <- if (!(color %in% c('light', 'white', 'info'))) 'text-white' else ''
  center <- if (center) 'text-center' else NULL
  small <- if (small) 'small' else NULL
  
  div(class = sprintf('bg-%s %s p-2', color, text_color), class = center, class = small,
      p(class = 'p-2 m-0', ...))
  
}

#' Single column layout
#'
#' Create a single coloumn responsive layout. This function should be used together with
#' \code{\link{saiPage}}.
#'
#' @param ... UI elements to include in the layout
#' @param fluid If \code{TRUE} use a fluid layout (100% width on all devices). If \code{FALSE}
#'   use a responsive layout. Defalts to \code{FALSE}
#'
#' @examples
#' # Simple "Hello world" example
#' saiPage(
#'   title = "Demo page",
#'   tabPanel(
#'     singleLayout(h1("Hello world"))
#'   )
#' )
#' @export
singleLayout <- function(..., fluid = FALSE) {

  class <- if (fluid) 'container-fluid mt-1' else 'container mt-1'
  
  div(class = class, div(class = 'row',
    div(class = 'col-12', ...)
  ))

}

#' Sidebar layout
#' 
#' @param menu The \code{\link{saiMenu}} containing input controls
#' @param main The \code{\link{saiMain}} containing outputs
#' @param position The position of the menu relative to the main area
#' @param fluid \code{TRUE} to use a fluid layout (100% width on all devices), or \code{FALSE}
#'   to use a responsive layout. Defalts to \code{TRUE}
#' 
#' @export
sidebarLayout <- function(menu, main, position = c('left', 'right'), fluid = TRUE) {
  
  position <- match.arg(position)
  class <- if (fluid) 'container-fluid' else 'container'
  
  if (position == 'left')
    divTag <- div(class = 'row', menu, main)
  else if (position == 'right')
    divTag <- div(class = 'row', main, menu)
  
  div(class = class,
    divTag
  )
  
}

buildNavbar <- function(title, tabs, tabselect, color = 'primary') {

  i <- 1
  tabs <- lapply(tabs, function(t) {

    class <- if (i == tabselect) 'nav-link active' else 'nav-link'
    id <- gsub('\\s', '', t$attribs$id)
    selected <- if (i == tabselect) 'true' else 'false'
    i <<- i + 1
    style <- if (t$attribs$`aria-hidden`) 'display: none;' else ''
    
    list(
      tags$li(class='nav-item', style = style, a(
        id = sprintf('%s-tab', id), class = class, `data-value` = t$attribs$id,
        `data-target` = sprintf('#%s', id), href = sprintf('#%s', id), `data-toggle` = 'pill',
        t$attribs$title, `role` = 'tab', `aria-selected` = selected, `aria-controls` = id)
      )
    )

  })

  list(
    tags$a(class='navbar-brand', href='#', title),
    tags$button(
      class = 'navbar-toggler', type = 'button', `data-toggle` = 'collapse', `data-target` = '#shinyNavbar',
      `aria-controls` = 'shinyNavbar', `aria-expanded` = 'false', `aria-label` = 'Toggle navigation',
      span(class = 'navbar-toggler-icon')
    ),
    tags$div(id = 'shinyNavbar', class='collapse navbar-collapse',
      tags$ul(class='nav navbar-nav mr-auto', `role` = 'tablist',
        tabs
      )
    )
  )

}

#' Create a tab panel
#'
#' Create a tab panel that can be included within a \code{tabsetPanel}. Overrides default Shiny
#'   \code{tabPanel}.
#'
#' @inheritParams shiny::tabPanel
#' 
#' @param class Additional classes to add to the tab.
#' @param icon Optional icon to appear on the tab.
#' @param hidden Boolean value. Should the tab be hidden from the menu? Defalts to \code{FALSE}
#'
#' @export
saiTab <- function(title, ..., value = title, class = NULL, icon = NULL, hidden = FALSE) {
  value <- tolower(gsub('[^[:alnum:]]', '', title))
  if (!is.null(class) && length(class) > 1) class <- paste(class, collapse = ' ')
  divTag <- div(
    class = if (!is.null(class)) sprintf('%s tab-pane fade', class) else 'tab-pane fade',
    id = value, title = title, role = 'tabpanel', `data-value` = value,
    `aria-labelledby` = sprintf('%s-tab', value),
    `aria-hidden` = if (hidden) 'true' else 'false', ...
  )
}

#' @rdname saiTab
#' @export
tabPanel <- saiTab

#' Create a tabset panel
#'
#' Create a tabset that contains \code{\link{tabPanel}} elements. Tabsets are
#' useful for dividing output into multiple independently viewable sections.
#'
#' @inheritParams shiny::tabsetPanel
#' 
#' @return A tabset that can be passed to \code{\link{mainPanel}}
#'
#' @seealso \code{\link{tabPanel}}, \code{\link{updateTabsetPanel}}
#'
#' @examples
#' # Show a tabset that includes a plot, summary, and
#' # table view of the generated distribution
#' mainPanel(
#'   tabsetPanel(
#'     tabPanel("Plot", plotOutput("plot")),
#'     tabPanel("Summary", verbatimTextOutput("summary")),
#'     tabPanel("Table", tableOutput("table"))
#'   )
#' )
#' @export
saiTabset <- function(
  ..., id = NULL, selected = NULL, type = c('tabs', 'pills'))
{

  if (!is.null(id))
    selected <- restoreInput(id = id, default = selected)

  # build the tabset
  tabs <- list(...)
  type <- match.arg(type)

  tabset <- buildTabset(tabs, sprintf('nav nav-%s my-2', type), NULL, id, selected)

  # create the content
  first <- tabset$navList
  second <- tabset$content

  # create the tab div
  tags$div(class = 'tabbable', first, second)
}

#' @rdname saiTabset
#' @export
tabsetPanel <- saiTabset

buildTabset <- function(
  tabs, ulClass, textFilter = NULL,  id = NULL, selected = NULL)
{

  # This function proceeds in two phases. First, it scans over all the items
  # to find and mark which tab should start selected. Then it actually builds
  # the tab nav and tab content lists.

  # Mark an item as selected
  markSelected <- function(x) {
    attr(x, 'selected') <- TRUE
    x
  }

  # Returns TRUE if an item is selected
  isSelected <- function(x) {
    isTRUE(attr(x, 'selected', exact = TRUE))
  }

  # Returns TRUE if a list of tab items contains a selected tab, FALSE otherwise.
  containsSelected <- function(tabs) {
    any(vapply(tabs, isSelected, logical(1)))
  }

  # Take a pass over all tabs, and mark the selected tab.
  foundSelectedItem <- FALSE
  findAndMarkSelected <- function(tabs, selected) {
    lapply(tabs, function(divTag) {
      if (foundSelectedItem) {
        # If we already found the selected tab, no need to keep looking

      } else if (is.character(divTag)) {
        # Strings don't represent selectable items

      } else if (inherits(divTag, "shiny.navbarmenu")) {
        # Navbar menu
        divTag$tabs <- findAndMarkSelected(divTag$tabs, selected)

      } else {
        # Regular tab item
        if (is.null(selected)) {
          # If selected tab isn't specified, mark first available item
          foundSelectedItem <<- TRUE
          divTag <- markSelected(divTag)

        } else {
          # If selected tab is specified, check for a match
          tabValue <- divTag$attribs$`data-value` %OR% divTag$attribs$title
          if (identical(selected, tabValue)) {
            foundSelectedItem <<- TRUE
            divTag <- markSelected(divTag)
          }
        }
      }

      return(divTag)
    })
  }

  # Append an optional icon to an aTag
  appendIcon <- function(aTag, iconClass) {
    if (!is.null(iconClass)) {
      # for font-awesome we specify fixed-width
      if (grepl("fa-", iconClass, fixed = TRUE))
        iconClass <- paste(iconClass, "fa-fw")
      aTag <- tagAppendChild(aTag, icon(name = NULL, class = iconClass))
    }
    aTag
  }

  # Build the tabset
  build <- function(tabs, ulClass, textFilter = NULL, id = NULL) {
    # add tab input sentinel class if we have an id
    if (!is.null(id))
      ulClass <- paste(ulClass, "shiny-tab-input")

    tabNavList <- tags$ul(class = ulClass, id = id)
    tabContent <- tags$div(class = 'tab-content')
    tabsetId <- 1000 + sample(9000, 1) - 1
    tabId <- 1

    buildItem <- function(divTag) {
      # check for text; pass it to the textFilter or skip it if there is none
      if (is.character(divTag)) {
        if (!is.null(textFilter)) {
          tabNavList <<- tagAppendChild(tabNavList, textFilter(divTag))
        }

      } else if (inherits(divTag, "shiny.navbarmenu")) {

        # create the a tag
        aTag <- tags$a(href="#", class="dropdown-toggle", `data-toggle`="dropdown")

        # add optional icon
        aTag <- appendIcon(aTag, divTag$iconClass)

        # add the title and caret
        aTag <- tagAppendChild(aTag, divTag$title)
        aTag <- tagAppendChild(aTag, tags$b(class="caret"))

        # build the dropdown list element
        liTag <- tags$li(class = "dropdown", aTag)

        # text filter for separators
        textFilter <- function(text) {
          if (grepl("^\\-+$", text))
            tags$li(class="divider")
          else
            tags$li(class="dropdown-header", text)
        }

        # build the child tabset
        tabset <- build(divTag$tabs, "dropdown-menu", textFilter)
        liTag <- tagAppendChild(liTag, tabset$navList)

        # If this navbar menu contains a selected item, mark it as active
        if (containsSelected(divTag$tabs)) {
          liTag$attribs$class <- paste(liTag$attribs$class, "active")
        }

        tabNavList <<- tagAppendChild(tabNavList, liTag)
        # don't add a standard tab content div, rather add the list of tab
        # content divs that are contained within the tabset
        tabContent <<- tagAppendChildren(tabContent, list = tabset$content$children)

      } else {
        # Standard navbar item
        # compute id and assign it to the div
        thisId <- paste("tab", tabsetId, tabId, sep="-")
        divTag$attribs$id <- thisId
        tabId <<- tabId + 1

        tabValue <- divTag$attribs$`data-value`

        # create the a tag
        aTag <- tags$a(
          href = sprintf('#%s', thisId), class = 'nav-link', `data-toggle` = 'tab',
          `data-target` = sprintf('#%s', thisId), `data-value` = tabValue)

        # append optional icon
        aTag <- appendIcon(aTag, divTag$attribs$`data-icon-class`)

        # add the title
        aTag <- tagAppendChild(aTag, divTag$attribs$title)

        # create the li tag
        liTag <- tags$li(class = 'nav-item', aTag)

        # If selected, set appropriate classes on li tag and div tag.
        if (isSelected(divTag)) {
          liTag$children[[1]]$attribs$class <- 'nav-link active'
          divTag$attribs$class <- 'tab-pane active'
        }

        divTag$attribs$title <- NULL

        # append the elements to our lists
        tabNavList <<- tagAppendChild(tabNavList, liTag)
        tabContent <<- tagAppendChild(tabContent, divTag)
      }
    }

    lapply(tabs, buildItem)
    list(navList = tabNavList, content = tabContent)
  }

  # Finally, actually invoke the functions to do the processing.
  tabs <- findAndMarkSelected(tabs, selected)
  build(tabs, ulClass, textFilter, id)
}

#' Create a help text element
#' 
#' @inherit shiny::helpText
#' 
#' @param small Should the text be smaller?
#' 
#' @export
helpText <- function(..., small = FALSE) {
  if (small)
    tags$small(class = 'text-muted', ...)
  else
    span(class = 'text-muted', ...)
}
