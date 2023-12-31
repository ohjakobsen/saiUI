% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dashboard.R
\name{dashboardCard}
\alias{dashboardCard}
\title{Create an information panel}
\usage{
dashboardCard(
  ...,
  header = NULL,
  footer = NULL,
  color = NULL,
  class = NULL,
  classes = NULL
)
}
\arguments{
\item{...}{The elements that should go into the card body}

\item{header}{Optional header to the card}

\item{footer}{Optional footer to the card}

\item{color}{Background color for the card. Must be a valid Bootstrap 4 color}

\item{class}{Additional CSS classes to apply to the div tag}

\item{classes}{Deprecated. Use \code{class} instead. Will be removed in version 0.6.0}
}
\description{
Creates a Bootstrap card. The card can be used to highlight content on a page. Can be used
together with \code{\link{cardGroup}}.
}
\details{
If you do not want cards with equal height and width, you can use \code{shiny}'s
\code{fluidRow} and \code{column} functions to create a responsive grid layout where
each card will be rendered individually.
}
\examples{
# Create a page with three linked cards
dashboardPanel(
  title = "Demo card deck",
  cardGroup(type = "deck",
    dashboardCard(header = "I'm a card", "This is the body"),
    dashboardCard(header = "I'm a different card", "This is the body"),
    dashboardCard(header = "I'm a red card", color = "danger", "This is the body")
  )
)

# Create a page with three individual cards
dashboardPanel(
  title = "demo",
  fluidRow(
    column(width = 4,
           dashboardCard(header = "I'm a card", "This is the body")
    ),
    column(width = 4,
           dashboardCard(header = "I'm a different card", "This is the body")
    ),
    column(width = 4,
           dashboardCard(header = "I'm a red card", color = "danger", "This is the body")
    )
  )
)

}
\seealso{
\code{\link{saiDashboard}} \code{\link{dashboardPanel}} \code{\link{cardGroup}}
}
