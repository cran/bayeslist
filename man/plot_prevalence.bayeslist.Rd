% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotfun.R
\name{plot_prevalence.bayeslist}
\alias{plot_prevalence.bayeslist}
\title{Plots of prevalence for bayeslist}
\usage{
plot_prevalence.bayeslist(
  object,
  covariate_names = NULL,
  only_prev = FALSE,
  xlim = NULL,
  inverse = FALSE,
  digit = 3,
  ...
)
}
\arguments{
\item{object}{A \code{bayeslist} object from running the main function \code{\link{bayeslist}}.}

\item{covariate_names}{Names of covariates.}

\item{only_prev}{Indicating whether only prevalence will be plotted. The default is FALSE.}

\item{xlim}{Limits of x-axis.}

\item{inverse}{Indicating whether prevalence should be calculated in the reverse order. The default is FALSE.}

\item{digit}{Digit number to be displayed.}

\item{...}{Additional parameters to be passed.}
}
\value{
None.
}
\description{
\code{plot_prevalence.bayeslist} is used to produce plots of prevalence from a \code{bayeslist} object from the main function \code{\link{bayeslist}}.
}
