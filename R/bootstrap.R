#' @import htmltools
NULL

#' Bootstrap Page
#'
#' @param ... The UI elements of the page.
#' @param title The title for the page
#' @param theme lternate Bootstrap 4 stylesheet.
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
    list(bs4Lib(), saiLib(), oiLib())
  )

}

#' Bootstrap Libraries
#'
#' This function returns a set of web dependencies necessary for using Bootstrap
#' components in a web page
#'
#' @param theme Alternate Bootstrap 4 stylesheet.
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

saiLib <- function() {
  htmlDependency('saiUI', '0.1.0',
    c(file = system.file('www', package = 'saiUI')),
    script = c('js/saiUI.min.js', 'js/bindings.js'),
    stylesheet = c('css/saiUi.min.css')
  )
}

oiLib <- function() {
  htmlDependency('open-iconic', '1.1.0',
    c(file = system.file('www/oi', package = 'saiUI')),
    stylesheet = c('css/open-iconic-bootstrap.min.css')
  )
}

#' SAI page element
#'
#' This functions builds the actual HTML page.
#'
#' @param title The title to display in the navbar.
#' @param ... The UI elements of the page. Top level elements should be \code{\link{tabPanel}}.
#' @param id The page ID
#' @param selected The tab that is initially selected
#' @param header Tag or list of tags to display as a common header above all tabPanels.
#' @param footer Tag or list of tags to display as a common footer below all tabPanels.
#' @param theme Alternate Bootstrap 4 stylesheet.
#' @param color Color for the navbar. Supports all Bootstrap 4 colors.
#' @param windowTitle The title that should be displayed by the browser window.
#'
#' @export
saiPage <- function(title,
                    ...,
                    id = NULL,
                    selected = NULL,
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

  # NOT SURE WHAT TO DO WITH THIS YET
  # contentDiv <- div(class=className("container"))
  # if (!is.null(header))
  #   contentDiv <- tagAppendChild(contentDiv, div(class="row", header))
  # contentDiv <- tagAppendChild(contentDiv, tabset$content)
  # if (!is.null(footer))
  #   contentDiv <- tagAppendChild(contentDiv, div(class="row", footer))

  # Build the page
  bs4Page(
    title = windowTitle,
    theme = theme,
    header,
    tags$nav(class = class, navItems),
    tags$div(class = 'tab-content', tabs)
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

  div(class=paste0('col-12 col-md-', width, ' bg-', color),
      tags$form(class='p-2',
                ...)
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

  div(class=paste0('col-12 col-md-', width),
      tags$section(class = 'p-2', ...)
      )

}

#' Single column layout
#'
#' @param ... UI elements to include in the layout
#' @param width The maximum width of the container i pixels. Default 1080.
#'
#' @export
singleLayout <- function(..., width = 1080) {

  div(class = 'mw-100 mx-auto', style = paste0('width: ', width, 'px'), div(class = 'row',
      div(class = 'col-12', ...)
      ))

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

#' Create a tab panel
#'
#' Create a tab panel that can be included within a \code{tabsetPanel}. Overrides default Shiny
#'   \code{tabPanel}.
#'
#' @param title Display title for tab.
#' @param ... UI elements to include within the tab.
#' @param value The value that should be sent when \code{tabsetPanel} reports that this tab is selected.
#' @param icon Optional icon to appear on the tab.
#'
#' @export
saiTab <- function(title, ..., value = title, icon = NULL, hidden = FALSE) {
  divTag <- div(class = 'tab-pane fade',
                id = gsub('\\s', '', title),
                title = title,
                `role` = 'tabpanel',
                `aria-labelledby` = paste0(gsub('\\s', '', title), '-tab'),
                `data-value` = value,
                `data-icon-class` = NULL,
                ...)
}

#' @rdname saiTab
#' @export
tabPanel <- saiTab

#' Create a tabset panel
#'
#' Create a tabset that contains \code{\link{tabPanel}} elements. Tabsets are
#' useful for dividing output into multiple independently viewable sections.
#'
#' @param ... \code{\link{tabPanel}} elements to include in the tabset
#' @param id If provided, you can use \code{input$}\emph{\code{id}} in your
#'   server logic to determine which of the current tabs is active. The value
#'   will correspond to the \code{value} argument that is passed to
#'   \code{\link{tabPanel}}.
#' @param selected The \code{value} (or, if none was supplied, the \code{title})
#'   of the tab that should be selected by default. If \code{NULL}, the first
#'   tab will be selected.
#' @param type Use "tabs" for the standard look; Use "pills" for a more plain
#'   look where tabs are selected using a background fill color.
#' @param position This argument is deprecated; it has been discontinued in
#'   Bootstrap 3.
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
saiTabset <- function(...,
                      id = NULL,
                      selected = NULL,
                      type = c('tabs', 'pills'),
                      position = NULL) {
  if (!is.null(position)) {
    shinyDeprecated(msg = paste("tabsetPanel: argument 'position' is deprecated;",
                                "it has been discontinued in Bootstrap 3."),
                    version = "0.10.2.2")
  }

  if (!is.null(id))
    selected <- restoreInput(id = id, default = selected)

  # build the tabset
  tabs <- list(...)
  type <- match.arg(type)

  tabset <- buildTabset(tabs, paste0("nav nav-", type), NULL, id, selected)

  # create the content
  first <- tabset$navList
  second <- tabset$content

  # create the tab div
  tags$div(class = "tabbable", first, second)
}

#' @rdname saiTabset
#' @export
tabsetPanel <- saiTabset

buildTabset <- function(tabs, ulClass, textFilter = NULL,
                        id = NULL, selected = NULL) {

  # This function proceeds in two phases. First, it scans over all the items
  # to find and mark which tab should start selected. Then it actually builds
  # the tab nav and tab content lists.

  # Mark an item as selected
  markSelected <- function(x) {
    attr(x, "selected") <- TRUE
    x
  }

  # Returns TRUE if an item is selected
  isSelected <- function(x) {
    isTRUE(attr(x, "selected", exact = TRUE))
  }

  # Returns TRUE if a list of tab items contains a selected tab, FALSE
  # otherwise.
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
    tabContent <- tags$div(class = "tab-content")
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
        tabContent <<- tagAppendChildren(tabContent,
                                         list = tabset$content$children)

      } else {
        # Standard navbar item
        # compute id and assign it to the div
        thisId <- paste("tab", tabsetId, tabId, sep="-")
        divTag$attribs$id <- thisId
        tabId <<- tabId + 1

        tabValue <- divTag$attribs$`data-value`

        # create the a tag
        aTag <- tags$a(href=paste("#", thisId, sep=""),
                       class = 'nav-link',
                       `data-toggle` = "tab",
                       `data-value` = tabValue)

        # append optional icon
        aTag <- appendIcon(aTag, divTag$attribs$`data-icon-class`)

        # add the title
        aTag <- tagAppendChild(aTag, divTag$attribs$title)

        # create the li tag
        liTag <- tags$li(class = 'nav-item', aTag)

        # If selected, set appropriate classes on li tag and div tag.
        if (isSelected(divTag)) {
          liTag$children[[1]]$attribs$class <- 'nav-link active'
          divTag$attribs$class <- "tab-pane active"
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

#' Searchbox input
#' 
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param button A character string to display as the text for the search button.
#' @param placeholder A character string giving the user a hint as to what can be entered into the
#'   control.
#' 
#' @export
searchboxInput <- function(inputId, value = '', button = 'Search', placeholder = NULL) {
  
  value <- shiny::restoreInput(id = inputId, default = value)
  
  div(class = "form-group shiny-input-container",
      tags$form(class = 'form-inline px-1 my-2', style = 'width: 100%;',
                tags$input(id = inputId, type="text", class="form-control searchbox mr-1", value = value,
                           style = 'flex-grow: 1; width: auto;', placeholder = placeholder),
                tags$button(class = 'btn btn-outline-success', `type` = 'submit', button)
      )
  )
  
}
