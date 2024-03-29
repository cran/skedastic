% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bootlm.R
\name{bootlm}
\alias{bootlm}
\title{Nonparametric Bootstrapping of Heteroskedastic Linear Regression Models}
\usage{
bootlm(
  object,
  sampmethod = c("pairs", "wild"),
  B = 1000L,
  resfunc = c("identity", "hccme"),
  fastfit = TRUE,
  ...
)
}
\arguments{
\item{object}{Either an object of class \code{"lm"} (generated by
\code{\link[stats]{lm}}), an object of class \code{"alvm.fit"}
(generated by \code{\link{alvm.fit}}), or an object of class
\code{"anlvm.fit"} (generated by \code{\link{anlvm.fit}})}

\item{sampmethod}{A character, either \code{"pairs"} or \code{"wild"},
indicating the method to be used to generate the resampled models:
bootstrapping pairs \insertCite{Efron93}{skedastic} or the wild bootstrap
\insertCite{Davidson08}{skedastic}. Defaults to \code{"pairs"}.}

\item{B}{An integer representing the number of bootstrapped linear
regression models to generate; defaults to \code{1000L}}

\item{resfunc}{Either a character naming a function to call to apply a
transformation to the Ordinary Least Squares residuals, or a function
to apply for the same purpose. This argument is ignored if
\code{sampmethod} is \code{"pairs"}. The only two character values
accepted are \code{"identity"}, in which case no transformation is
applied to the residuals, and \code{"hccme"}, in which case the
transformation corresponds to a heteroskedasticity-consistent
covariance matrix estimator calculated from \code{\link{hccme}}. If
\code{resfunc} is a function, it is assumed that its first argument
is the numeric vector of residuals.}

\item{fastfit}{A logical indicating whether the \code{\link[stats]{lm.fit}}
function should be used to fit the bootstrapped regression models for
greater computational speed; defaults to \code{TRUE}. This affects the
class of the returned value (see below). If \code{FALSE},
\code{\link[stats]{lm}} is used to fit the bootstrapped regression
models.}

\item{...}{Other arguments to pass to \code{\link{hccme}}}
}
\value{
A list object of class \code{"bootlm"}, containing \code{B} objects,
   each of which is a bootstrapped linear regression model fit by Ordinary
   Least Squares. If \code{fastfit} was set to \code{TRUE}, each of these
   objects will be a list containing named objects \code{y} (the bootstrap
   response vector), \code{X} (the bootstrap design matrix, which is just
   the original design matrix under the wild bootstrap), \code{e} (the
   residual vector from the Ordinary Least Squares fit to this bootstrap
   data set), \code{beta.hat} (the vector of coefficient estimates from the
   Ordinary Least Squares fit to this bootstrap data set),
   \code{sampmethod}, and \code{ind} (a vector of the indices from the
   original data set used in this bootstrap sample; ignored under the
   wild bootstrap)
   of the kind returned by
   \code{\link[stats]{lm.fit}}; otherwise, each will be an object of class
   \code{"lm"}.
}
\description{
Generates \eqn{B} nonparametric bootstrap replications of a linear
   regression model that may have heteroskedasticity.
}
\details{
Each replication of the pairs bootstrap entails drawing a sample
   of size \eqn{n} (the number of observations) with replacement from the
   indices \eqn{i=1,2,\ldots,n}. The pair or case \eqn{(y_i, X_i)} is
   included as an observation in the bootstrapped data set for each sampled
   index. An Ordinary Least Squares fit to the bootstrapped data set is then
   computed.

Under the wild bootstrap, each replication of the linear regression model
   is generated by first independently drawing \eqn{n} random values
   \eqn{r_i}, \eqn{i=1,2,\ldots,n}, from a distribution with zero mean and
   unit variance. The \eqn{i}th bootstrap response is then computed as
   \deqn{X_i'\hat{\beta} + f_i(e_i) r_i}, where \eqn{X_i} is the \eqn{i}th
   design observation, \eqn{\hat{\beta}} is the Ordinary Least Squares
   estimate of the coefficient vector \eqn{\beta}, \eqn{e_i} is the
   \eqn{i}th Ordinary Least Squares residual, and \eqn{f_i(\cdot)} is a
   function performing some transformation on the residual. An Ordinary
   Least Squares fit is then computed on the original design matrix and the
   bootstrap response vector.
}
\examples{
mtcars_lm <- lm(mpg ~ wt + qsec + am, data = mtcars)
mybootlm <- bootlm(mtcars_lm)

}
\references{
{\insertAllCited{}}
}
\seealso{
\code{\link[lmboot]{paired.boot}} and
   \code{\link[lmboot]{wild.boot}} for the pairs bootstrap and wild
   bootstrap, respectively. The latter function does not appear to allow
   transformations of the residuals in the wild bootstrap.
}
