% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/alvm.fit.R
\name{alvm.fit}
\alias{alvm.fit}
\title{Auxiliary Linear Variance Model}
\usage{
alvm.fit(
  mainlm,
  M = NULL,
  model = c("cluster", "spline", "linear", "polynomial", "basic", "homoskedastic"),
  varselect = c("none", "hettest", "cv.linear", "cv.cluster", "qgcv.linear",
    "qgcv.cluster"),
  lambda = c("foldcv", "qgcv"),
  nclust = c("elbow.swd", "elbow.mwd", "elbow.both", "foldcv"),
  clustering = NULL,
  polypen = c("L2", "L1"),
  d = 2L,
  solver = c("auto", "quadprog", "quadprogXT", "roi", "osqp"),
  tsk = NULL,
  tsm = NULL,
  constol = 1e-10,
  cvoption = c("testsetols", "partitionres"),
  nfolds = 5L,
  reduce2homosked = TRUE,
  ...
)
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

\item{M}{An \eqn{n\times n} annihilator matrix. If \code{NULL}
(the default), this will be calculated from the \code{mainlm} object}

\item{model}{A character corresponding to the type of ALVM to be fitted:
\code{"cluster"} for the clustering ALVM, \code{"spline"} for the
thin-plate spline ALVM, \code{"linear"} for the linear ALVM,
\code{"polynomial"} for the penalised polynomial ALVM, \code{"basic"} for
the basic or naive ALVM, and \code{"homoskedastic"} for the
homoskedastic error variance estimator, \eqn{e'e/(n-p)}.}

\item{varselect}{Either a character indicating how variable selection should
   be conducted, or an integer vector giving indices of columns of the
   predictor matrix (\code{\link[stats]{model.matrix}} of \code{mainlm})
   to select. The vector must include \code{1L} for the intercept to be
   selected. If a character, it must be one of the following:
\itemize{
 \item \code{"none"}: No variable selection is conducted;
 \item \code{"hettest"}: Variable selection is conducted by applying a
   heteroskedasticity test with each feature in turn serving as the
   `deflator' variable
 \item \code{"cv.linear"}: Variable selection is conducted by best subset
   selection on the auxiliary linear variance model (linear specification),
   using squared-error loss computed under \eqn{K}-fold cross-validation
 \item \code{"cv.cluster"}: Variable selection is conducted by best subset
   selection on the auxiliary linear variance model (clustering
   specification), using squared-error loss computed under \eqn{K}-fold
   cross-validation
 \item \code{"qgcv.linear"}: Variable selection is conducted by best subset
   selection on the auxiliary linear variance model (linear specification),
   using squared-error loss computed under quasi-generalised
   cross-validation
 \item \code{"qgcv.cluster"}: Variable selection is conducted by best subset
   selection on the auxiliary linear variance model (clustering
   specification), using squared-error loss computed under
   quasi-generalised cross-validation
}}

\item{lambda}{Either a double of length 1 indicating the value of the
penalty hyperparameter \eqn{\lambda}, or a character specifying the
tuning method for choosing \eqn{\lambda}: \code{"foldcv"} for
\eqn{K}-fold cross-validation (the default) or \code{"qgcv"} for
quasi-generalised cross-validation. This argument is ignored if
\code{model} is neither \code{"polynomial"} nor \code{"spline"}.}

\item{nclust}{Either an integer of length 1 indicating the value of the
number of clusters \eqn{n_c}, or a character specifying the tuning method
for choosing \eqn{n_c}: \code{"elbow.swd"} for the elbow method using a
sum of within-cluster distances criterion,  \code{"elbow.mwd"} for the
elbow method using a maximum within-cluster distances criterion,
\code{"elbow.both"} for rounded average of the results of the previous
two, and \code{"foldcv"} for \eqn{K}-fold cross-validation. This argument
is ignored if \code{model} is not \code{"cluster"}.}

\item{clustering}{A list object of class \code{"doclust"}. If set to
\code{NULL} (the default), such an object is generated (ignored if
\code{cluster} is \code{FALSE})}

\item{polypen}{A character, either \code{"L2"} or \code{"L1"}, indicating
whether an \eqn{L_2} norm penalty (ridge regression) or
\eqn{L_1} norm penalty (LASSO) should be used with the polynomial model.
This argument is ignored if \code{model} is not \code{"polynomial"}.}

\item{d}{An integer specifying the degree of polynomial to use in the
penalised polynomial ALVM; defaults to \code{2L}. Ignored if
\code{model} is other than \code{"polynomial"}. Setting \code{d} to
\code{1L} is not identical to setting \code{model} to \code{"linear"},
because the linear ALVM does not have a penalty term in the objective
function.}

\item{solver}{A character, indicating which Quadratic Programming solver
function to use to estimate \eqn{\gamma}. The options are
\code{"quadprog"}, corresponding to
\code{\link[quadprog]{solve.QP.compact}} from the \pkg{quadprog} package;
package; \code{"quadprogXT"}, corresponding to
\code{\link[quadprogXT]{buildQP}} from the \pkg{quadprogXT} package;
\code{"roi"}, corresponding to the \code{qpoases} solver implemented in
\code{\link[ROI]{ROI_solve}} from the \pkg{ROI} package with
\pkg{ROI.plugin.qpoases} add-on; and \code{"osqp"}, corresponding to
\code{\link[osqp]{solve_osqp}} from the \pkg{osqp} package.
Alternatively, the user can specify \code{"auto"} (the default), in which
case the function will select the solver that seems to work best for the
chosen model.}

\item{tsk}{An integer corresponding to the basis dimension \code{k} to be
passed to the \code{[mgcv]{s}} function for fitting of a thin-plate
spline ALVM; see \code{[mgcv]{choose.k}} for more details about
choosing the parameter and defaults. Ignored if \code{model} is not
\code{"spline"}.}

\item{tsm}{An integer corresponding to the order \code{m} of the penalty
to be passed to the \code{[mgcv]{s}} function for fitting of a thin-plate
spline ALVM. If left as the default (\code{NULL}), it will be set to
2, corresponding to 2nd derivative penalties for a cubic spline.}

\item{constol}{A double corresponding to the boundary value for the
constraint on error variances. Of course, the error variances must be
non-negative, but setting the constraint boundary to 0 can result in
zero estimates that then result in infinite weights for Feasible
Weighted Least Squares. The boundary value should thus be positive, but
small enough not to bias estimation of very small variances. Defaults to
\code{1e-10}.}

\item{cvoption}{A character, either \code{"testsetols"} or
\code{"partitionres"}, indicating how to obtain the observed response
values for each test fold when performing \eqn{K}-fold cross-validation
on an ALVM. The default technique, \code{"testsetols"}, entails fitting
a linear regression model to the test fold of observations from the
original response vector \eqn{y} and predictor matrix \eqn{X}. The
squared residuals from this regression are the observed
responses that are predicted from the trained model to compute the
cross-validated squared error loss function. Under the other technique,
\code{"partitionres"}, the squared residuals from the full
linear regression model are partitioned into training and test folds and
the squared residuals in the test fold are the observed responses that
are predicted for computation of the cross-validated loss.}

\item{nfolds}{An integer specifying the number of folds \eqn{K} to use for
cross-validation, if the \eqn{\lambda} and/or \eqn{n_c} hyperparameters
are to be tuned using cross-validation. Defaults to \code{5L}. One must
ensure that each test fold contains at least \eqn{p+1} observations if
the \code{"testsetols"} technique is used with cross-validation, so that
there are enough degrees of freedom to fit a linear model to the test
fold.}

\item{reduce2homosked}{A logical indicating whether the homoskedastic
error variance estimator \eqn{e'e/(n-p)} should be used if the
variable selection procedure does not select any variables. Defaults to
\code{TRUE}.}

\item{...}{Other arguments that can be passed to (non-exported) helper
   functions, namely:
\itemize{
 \item \code{greedy}, a logical passed to the functions implementing best subset
   selection, indicating whether or not to use a greedy search rather than
   exhaustive search for the best subset. Defaults to \code{FALSE}, but
   coerced to \code{TRUE} unconditionally if \eqn{p>9}.
\item \code{distmetric}, a character specifying the distance metric to use in
   computing distance for the clustering algorithm. Corresponds to the
   \code{method} argument of \code{\link[stats]{dist}} and defaults to
   \code{"euclidean"}
\item \code{linkage}, a character specifying the linkage rule to use in
   agglomerative hierarchical clustering. Corresponds to the \code{method}
   argument of \code{\link[stats]{hclust}} and defaults to
   \code{"complete"}
\item \code{nclust2search}, an integer vector specifying the values of
   \eqn{n_c} to try when tuning \eqn{n_c} by cross-validation. Defaults to
   \code{1L:20L}
\item \code{alpha}, a double specifying the significance level threshold to
   use when applying heteroskedasticity test for the purpose of feature
   selection in an ALVM; defaults to \code{0.1}
\item \code{testname}, a character corresponding to the name of a function
   that performs a heteroskedasticity test. The function must either be one
   that takes a \code{deflator} argument or \code{\link{breusch_pagan}}.
   Defaults to \code{evans_king}
}}
}
\value{
An object of class \code{"alvm.fit"}, containing the following:
\itemize{
 \item \code{coef.est}, a vector of parameter estimates, \eqn{\hat{\gamma}}
 \item \code{var.est}, a vector of estimates \eqn{\hat{\omega}} of the error
   variances for all observations
 \item \code{method}, a character corresponding to the \code{model} argument
 \item \code{ols}, the \code{lm} object corresponding to the original linear
   regression model
 \item \code{fitinfo}, a list containing four named objects: \code{Msq} (the
   elementwise-square of the annihilator matrix \eqn{M}), \code{L} (the
   linear predictor matrix \eqn{L}), \code{clustering} (a list object
   with results of the clustering procedure), and \code{gam.object}, an
   object of class \code{"gam"} (see \code{\link[mgcv]{gamObject}}). The
   last two are set to \code{NA} unless the clustering ALVM or thin-plate
   spline ALVM is used, respectively
 \item \code{hyperpar}, a named list of hyperparameter values,
   \code{lambda}, \code{nclust}, \code{tsk}, and \code{d}, and tuning
   methods, \code{lambdamethod} and \code{nclustmethod}. Values
   corresponding to unused hyperparameters are set to \code{NA}.
 \item \code{selectinfo}, a list containing two named objects,
   \code{varselect} (the value of the eponymous argument), and
   \code{selectedcols} (a numeric vector with column indices of \eqn{X}
   that were selected, with \code{1} denoting the intercept column)
 \item \code{pentype}, a character corresponding to the \code{polypen}
   argument
 \item \code{solver}, a character corresponding to the \code{solver}
   argument (or specifying the QP solver actually used, if \code{solver}
   was set to \code{"auto"})
 \item \code{constol}, a double corresponding to the \code{constol} argument
}
}
\description{
Fits an Auxiliary Linear Variance Model (ALVM) to estimate the error
   variances of a heteroskedastic linear regression model.
}
\details{
The ALVM model equation is
   \deqn{e\circ e = (M \circ M)L \gamma + u},
   where \eqn{e} is the Ordinary Least Squares residual vector, \eqn{M} is
   the annihilator matrix \eqn{M=I-X(X'X)^{-1}X'}, \eqn{L} is a linear
   predictor matrix, \eqn{u} is a random error vector, \eqn{\gamma} is a
   \eqn{p}-vector of unknown parameters, and \eqn{\circ} denotes the
   Hadamard (elementwise) product. The construction of \eqn{L} depends on
   the method used to model or estimate the assumed heteroskedastic
   function \eqn{g(\cdot)}, a continuous, differentiable function that is
   linear in \eqn{\gamma} and by which the error variances \eqn{\omega_i}
   of the main linear model are related to the predictors \eqn{X_{i\cdot}}.
   This method has been developed as part of the author's doctoral research
   project.

Depending on the model used, the estimation method could be
   Inequality-Constrained Least Squares or Inequality-Constrained Ridge
   Regression. However, these are both special cases of Quadratic
   Programming. Therefore, all of the models are fitted using Quadratic
   Programming.

Several techniques are available for feature selection within the model.
   The LASSO-type model handles feature selection via a shrinkage penalty.
   For this reason, if the user calls the polynomial model with
   \eqn{L_1}-norm penalty, it is not necessary to specify a variable
   selection method, since this is handled automatically. Another feature
   selection technique is to use a heteroskedasticity test that tests for
   heteroskedasticity linked to a particular predictor variable (the
   `deflator'). This test can be conducted with each features in turn
   serving as the deflator. Those features for which the null hypothesis of
   homoskedasticity is rejected at a specified significance level
   \code{alpha} are selected. A third feature selection technique is best
   subset selection, where the model is fitted with all possible subsets of
   features. The models are scored in terms of some metric, and the
   best-performing subset of features is selected. The metric could be
   squared-error loss computed under \eqn{K}-fold cross-validation or using
   quasi-generalised cross-validation. (The \emph{quasi-} prefix refers to
   the fact that generalised cross-validation is, properly speaking, only
   applicable to a linear fitting method, as defined by
   \insertCite{Hastie09;textual}{skedastic}. ALVMs are not linear fitting
   methods due to the inequality constraint). Since best subset selection
   requires fitting \eqn{2^{p-1}} models (where \eqn{p-1} is the number of
   candidate features), it is infeasible for large \eqn{p}. A greedy search
   technique can therefore be used as an alternative, where one begins with
   a null model and adds the feature that leads to the best improvement in
   the metric, stopping when no new feature leads to an improvement.

The polynomial and thin-plate spline ALVMs have a penalty hyperparameter
   \eqn{\lambda} that must either be specified or tuned. \eqn{K}-fold
   cross-validation or quasi-generalised cross-validation can be used for
   tuning. The clustering ALVM has a hyperparameter \eqn{n_c}, the number of
   clusters into which to group the observations (where error variances
   are assumed to be equal within each cluster). \eqn{n_c} can be specified
   or tuned. The available tuning methods are an elbow method (using a
   sum of within-cluster distances criterion, a maximum
   within-cluster distance criterion, or a combination of the two) and
   \eqn{K}-fold cross-validation.
}
\examples{
mtcars_lm <- lm(mpg ~ wt + qsec + am, data = mtcars)
myalvm <- alvm.fit(mtcars_lm, model = "cluster")

}
\references{
{\insertAllCited{}}
}
\seealso{
\code{\link{alvm.fit}}, \code{\link{avm.ci}}
}
