#' Dashboard page
#'
#' Create a dashboard page that can be used with \code{\link{dashboardPanel}}s.
#'
#' @inheritParams bs4Page
#' @param title The title for the page.
#' @param ... The UI elements of the page.
#' @param selected The \code{value} of the panel that should be selected by default.
#'   If \code{NULL}, the first panel will be selected.
#' @param color A string indicating the color of the top navigation
#' @param brand A string indicating the brand for the page
#' @param windowTitle The title that should be displayed by the browser window.
#' @param header Tag or list of tags to display on top of page.
#' @param footer Tag or list of tags to display on the botton of the page.
#'
#' @seealso \code{\link{dashboardPanel}}
#'
#' @export
saiDashboard <- function(title, ..., selected = NULL, color = 'dark', brand = title,
                         windowTitle = title, header = NULL, footer = NULL, lang = 'en',
                         dir = 'ltr') {

  pageTitle <- title

  if (nzchar(tools::file_ext(brand)))
    brandTag <- a(class = 'navbar-brand', href = '#', img(src = brand, height = '30'))
  else
    brandTag <- a(class = 'navbar-brand', href = '#', brand)

  topNav <- tags$nav(
    class = sprintf('mainnav navdashboard navbar navbar-dark sticky-top bg-%s flex-md-nowrap p-0', color),
    div(id = 'sidebarHeader', class = 'col-lg-2 mr-0',
      brandTag,
      tags$button(
        class = 'navbar-toggler', `data-toggle` = 'collapse', `data-target` = '#mainnav',
        `aira-controls` = 'mainnav', `aria-expanded` = 'false', `aria-label` = 'Toggle navigation',
        tags$span(class = 'navbar-toggler-icon')
      )
    )
  )

  tabs <- list(...)

  selected <- restoreInput('pagenav', default = selected)

  if (!is.null(selected))
    tabselect <- which(sapply(tabs, function(t) t$attribs$id) == selected)
  else
    tabselect <- 1

  tabs[[tabselect]]$attribs$class <- 'tab-pane fade show active'

  navItems <- buildDashboardNav(tabs, tabselect)

  contentDiv <- div(class = 'ml-lg-auto col-lg-10 pt-3 px-lg-4',
                    div(class = 'tab-content', tabs))

  deps <- list(htmlDependency(
    'dashboard', packageVersion('saiUI'),
    c(file = system.file('www', package = 'saiUI')),
    stylesheet = c('css/dashboard.min.css')
  ))

  bs4Page(
    title = windowTitle,
    theme = NULL,
    lang = lang,
    dir = dir,
    deps = deps,
    header,
    topNav,
    div(class = 'container-fluid',
      div(class = 'row',
        navItems,
        contentDiv
      )
    ),
    footer
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
#'   \item{\code{star}}
#'   }
#'
#' @export
dashboardPanel <- function(title, ..., id = title, value = id, icon = 'dashboard') {

  id <- tolower(gsub(' ', '', id, fixed = TRUE))

  divTag <- div(
    class = 'tab-pane fade', id = id, title = title, role = 'tabpanel',
    `aria-labelledby` = sprintf('%s-tab', id), `data-value` = value,
    `data-icon-class` = icon, ...)

}

# Build functions for dashboard layout
buildDashboardNav <- function(tabs, tabselect) {

  # TODO: Fix in IE11 (brand not showing b/c of fixed positioning)
  i <- 1

  tabs <- lapply(tabs, function(t) {

    icon <- tags$i(class = sprintf('oi oi-%s', t$attribs$`data-icon-class`))
    class <- ifelse(i == tabselect, 'nav-link active', 'nav-link')
    id <- gsub('\\s', '', t$attribs$id)
    selected <- ifelse(i == tabselect, 'true', 'false')
    i <<- i + 1

    tags$li(class = 'nav-item', a(
      id = sprintf('%s-tab', id), class = class, `data-target` = sprintf('#%s', id),
      href = sprintf('#%s', id), `data-value` = t$attribs$`data-value`, `data-toggle` = 'tab',
      `role` = 'tab', `aria-selected` = selected, `aria-controls` = id,
      list(icon, t$attribs$title))
    )

  })

  tags$nav(id = 'mainnav', class = 'col-lg-2 d-lg-block bg-light sidebar navbar-collapse collapse',
    div(id = 'pagenav', class = 'sidebar-sticky',
      tags$ul(id = 'navlist', class = 'nav flex-column', role = 'tablist',
        tabs
      )
    )
  )

}

#' Create an information panel
#'
#' Creates a Bootstrap card. The card can be used to highlight content on a page. Can be used
#' together with \code{\link{cardGroup}}.
#'
#' If you do not want cards with equal height and width, you can use \code{shiny}'s
#' \code{fluidRow} and \code{column} functions to create a responsive grid layout where
#' each card will be rendered individually.
#'
#' @param ... The elements that should go into the card body
#' @param header Optional header to the card
#' @param footer Optional footer to the card
#' @param color Background color for the card. Must be a valid Bootstrap 4 color
#' @param class Additional CSS classes to apply to the div tag
#' @param classes Deprecated. Use \code{class} instead. Will be removed in version 0.6.0
#'
#' @examples
#' # Create a page with three linked cards
#' dashboardPanel(
#'   title = "Demo card deck",
#'   cardGroup(type = "deck",
#'     dashboardCard(header = "I'm a card", "This is the body"),
#'     dashboardCard(header = "I'm a different card", "This is the body"),
#'     dashboardCard(header = "I'm a red card", color = "danger", "This is the body")
#'   )
#' )
#'
#' # Create a page with three individual cards
#' dashboardPanel(
#'   title = "demo",
#'   fluidRow(
#'     column(width = 4,
#'            dashboardCard(header = "I'm a card", "This is the body")
#'     ),
#'     column(width = 4,
#'            dashboardCard(header = "I'm a different card", "This is the body")
#'     ),
#'     column(width = 4,
#'            dashboardCard(header = "I'm a red card", color = "danger", "This is the body")
#'     )
#'   )
#' )
#'
#' @seealso \code{\link{saiDashboard}} \code{\link{dashboardPanel}} \code{\link{cardGroup}}
#'
#' @export
dashboardCard <- function(..., header = NULL, footer = NULL, color = NULL, class = NULL, classes = NULL) {

  if (!is.null(classes)) {
    message('In dashboardCard(): classes is deprecated, use class instead')
    class <- classes
  }

  if (length(class) > 1L) class <- paste(class, collapse = ' ')

  if (is.null(color))
    class <- paste('card', class)
  else if (color == 'light')
    class <- paste('card bg-light', class)
  else
    class <- paste(paste0('card text-white bg-', color), class)

  divTag <- div(class = class)

  # Add elements to card
  if (!is.null(header)) divTag <- tagAppendChild(divTag, div(class = 'card-header', header))
  divTag <- tagAppendChild(divTag, div(class = 'card-body', ...))
  if (!is.null(footer)) divTag <- tagAppendChild(divTag, div(class = 'card-footer', footer))

  divTag

}

#' Create a group of two or more \code{\link{dashboardCard}}s
#'
#' Create a group of two or more \code{\link{dashboardCard}}s. Two types of groups are
#' supported; \code{group} and \code{deck}. See details.
#'
#' The cards the the group will be of equal height and fill the full width on big screen devices.
#' The cards are responsive. When the \code{type} is set to \code{group}, the cards are grouped
#' together with no space between them. Headers and footers will automatically line up. When the
#' \code{type} is set to \code{deck} the cards will be set to equal width and height, but will
#' show as individual cards.
#'
#' @param ... Two or more \code{\link{dashboardCard}}s to go into the group.
#' @param type The type of card group. Can be either \code{group} or \code{deck}.
#' @param class Additional CSS classes to apply to the div tag
#'
#' @seealso \code{\link{dashboardCard}}
#'
#' @export
cardGroup <- function(..., type = c('group', 'deck'), class = NULL) {

  type <- match.arg(type)

  if (length(class) > 1L) class <- paste(class, collapse = ' ')
  if (!is.null(class))
    class <- paste(sprintf('card-%s', type), class)
  else
    class <- sprintf('card-%s', type)

  div(class = class, ...)

}

#' Card with navigation
#'
#' Create a card with several \code{\link{cardNavItem}}s the user can navigate to. See details.
#'
#' @param navId The ID of the card
#' @param ... One or more nav items of type \code{\link{cardNavItem}}
#'
#' @examples
#' # Build a card with three navigatable items
#' cardNav(
#'   navId = 'cardnav',
#'   cardNavItem(cardId = 'first', title = 'First', 'Content of first tab'),
#'   cardNavItem(cardId = 'second', title = 'Second', 'Content of second tab'),
#'   cardNavItem(cardId = 'third', title = 'Third', 'Content of third tab')
#' )
#'
#' @export
cardNav <- function(navId, ...) {

  items <- list(...)

  # Combine IDs for nav and nav items
  items <- lapply(items, function(el) {
    orgId <- el$attribs$id
    el$attribs$id <- paste(navId, orgId, sep = '-')
    return(el)
  })

  # Add active class to the first element
  items[[1]]$attribs$class <- paste(items[[1]]$attribs$class, 'active show')

  # Build the card navigation list. The first element should be active
  i <- 1
  cardNav <- lapply(items, function(el) {

    id <- el$attribs$id
    title <- el$attribs$`data-title`
    class <- ifelse(i == 1, 'nav-link active', 'nav-link')
    i <<- i + 1

    tags$li(
      class = 'nav-item',
      tags$a(class = class, `data-toggle` = 'tab', role = 'tab', href = paste0('#', id), title)
    )

  })

  # Finally build the actual card output
  div(class = 'card',
    div(class = 'card-header',
      tags$ul(
        class = 'nav nav-tabs card-header-tabs', role = 'tablist',
        cardNav
      )
    ),
    div(class = 'card-body', div(class = 'tab-content', items))
  )

}

#' Item for card with navigation
#'
#' Create a card item that can be included in a \code{\link{cardNav}}
#'
#' @param cardId The ID for the card body
#' @param title The title for the card. Defaults to the ID.
#' @param ... UT elements to include within the card body
#'
#' @seealso \code{\link{cardNav}}
#'
#' @export
cardNavItem <- function(cardId, title = cardId, ...) {

  div(class = 'tab-pane fade', id = cardId, `data-title` = title, ...)

}
