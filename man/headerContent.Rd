% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bootstrap.R
\name{headerContent}
\alias{headerContent}
\title{Add content to page header}
\usage{
headerContent(..., color = "primary", wrapper = TRUE, small = FALSE)
}
\arguments{
\item{...}{The text to be included}

\item{color}{The background color for the text. See details}

\item{wrapper}{If \code{TRUE} the text will be wrapped in a paragraph tag}

\item{small}{If \code{TRUE} the text will be smaller than the body text}
}
\description{
Add a text message above the content area on \code{\link{saiPage}}
}
\details{
Color can be either a valid bootstrap color, or a hexadecimal string
of the form "\code{#rrggbb}". See \code{\link[grDevices]{rgb}}.
}
