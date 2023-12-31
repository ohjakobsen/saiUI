% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ui-elements.R
\name{bs4Dropdown}
\alias{bs4Dropdown}
\title{Create Bootstrap dropdown button with custom UI}
\usage{
bs4Dropdown(
  title,
  ...,
  color = "primary",
  outline = FALSE,
  size = c("normal", "sm", "lg"),
  width = 400,
  direction = c("down", "right", "up", "left"),
  autoclose = TRUE
)
}
\arguments{
\item{title}{The name of the dropdown button}

\item{...}{UI elements in the dropdown}

\item{color}{The color of the dropdown button}

\item{outline}{If \code{TRUE} display an outline button}

\item{size}{A character string giving the size of the input. Valid options are \code{normal},
\code{sm} and \code{lg}. Defaults to \code{normal}}

\item{width}{The width of the dropdown in pixels}

\item{direction}{The direction of the dropdown Default value \code{'down'}.}

\item{autoclose}{If \code{TRUE} the dropdown will close when the user clicks inside it}
}
\description{
Create Bootstrap dropdown button with custom UI
}
