% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/yuce.R
\name{yuce}
\alias{yuce}
\title{Yüce's Test for Heteroskedasticity in a Linear Regression Model}
\usage{
yuce(mainlm, method = c("A", "B"), statonly = FALSE)
}
\arguments{
\item{mainlm}{Either an object of \code{\link[base]{class}} \code{"lm"}
(e.g., generated by \code{\link[stats]{lm}}), or
a list of two objects: a response vector and a design matrix. The objects
are assumed to be in that order, unless they are given the names
\code{"X"}  and \code{"y"} to distinguish them. The design matrix passed
in a list must begin with a column of ones if an intercept is to be
included in the linear model. The design matrix passed in a list should
not contain factors, as all columns are treated 'as is'. For tests that
use ordinary least squares residuals, one can also pass a vector of
residuals in the list, which should either be the third object or be
named \code{"e"}.}

\item{method}{A character indicating which of the two tests presented in
\insertCite{Yuce08;textual}{skedastic} should be implemented. Possible
values are \code{"A"} (the chi-squared test) and
\code{"B"} (the \eqn{t}-test). Partial matching is used and the argument
is not case-sensitive.}

\item{statonly}{A logical. If \code{TRUE}, only the test statistic value
is returned, instead of an object of \code{\link[base]{class}}
\code{"htest"}. Defaults to \code{FALSE}.}
}
\value{
An object of \code{\link[base]{class}} \code{"htest"}. If object is
   not assigned, its attributes are displayed in the console as a
   \code{\link[tibble]{tibble}} using \code{\link[broom]{tidy}}.
}
\description{
This function implements the two methods of
   \insertCite{Yuce08;textual}{skedastic} for testing for heteroskedasticity
   in a linear regression model.
}
\details{
These two tests are straightforward to implement; in both cases the
   test statistic is a function only of the residuals of the linear
   regression model. The first test statistic has an asymptotic chi-squared
   distribution and the second has an asymptotic \eqn{t}-distribution. In
   both cases the degrees of freedom are \eqn{n-p}. The chi-squared test
   is right-tailed whereas the \eqn{t}-test is two-tailed.
}
\examples{
mtcars_lm <- lm(mpg ~ wt + qsec + am, data = mtcars)
yuce(mtcars_lm, method = "A")
yuce(mtcars_lm, method = "B")

}
\references{
{\insertAllCited{}}
}
