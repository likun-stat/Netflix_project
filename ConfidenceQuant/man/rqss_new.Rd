% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rqss_new.R
\name{rqss_new}
\alias{rqss_new}
\title{Additive Quantile Regression Smoothing}
\usage{
rqss_new(formula, tau = 0.5, data = parent.frame(), weights, na.action,
  method = "sfn", lambda = NULL, contrasts = NULL, ztol = 1e-05,
  control = sfn.control(), ...)
}
\arguments{
\item{formula}{a formula object, with the response on the left of a `~'
operator,  and terms, separated by `+' operators, on the right. The terms
may include \code{qss} terms that represent additive nonparametric
components.  These terms can be univariate or bivariate.  See
\code{\link{qss}} for details on how to specify these terms.}

\item{tau}{the quantile to be estimated, this must be a number between 0 and
1.}

\item{data}{a data.frame in which to interpret the variables named in the
formula, or in the subset and the weights argument.}

\item{weights}{vector of observation weights. The length of weights must be
the same as the number of observations.  The weights must be positive
integers which basically indicates the number of repeats.}

\item{na.action}{a function to filter missing data. This is applied to the
model.frame after any subset argument has been used. The default (with
\code{na.fail}) is to create an error if any missing values are found.  A
possible alternative is \code{na.omit}, which deletes observations that
contain one or more missing values.}

\item{method}{the algorithmic method used to compute the fit.  There are
  currently two options.   Both are implementations of the Frisch--Newton
  interior point method described in detail in Portnoy and Koenker(1997).
  Both are implemented using sparse Cholesky decomposition as described in
  Koenker and Ng (2003).

  Option \code{"sfnc"} is used if the user specifies inequality constraints.
  Option \code{"sfn"} is used if there are no inequality constraints. Linear
  inequality constraints on the fitted coefficients are specified by a matrix
  \code{R} and a vector \code{r}, specified inside the \code{qss} terms,
  representing the constraints in the form \eqn{Rb \ge r}{Rb >= r}.

  The option \code{method = "lasso"} allows one to penalize the coefficients
  of the covariates that have been entered linearly as in
  \code{\link{rq.fit.lasso}}; when this is specified then there should be an
  additional \code{lambda} argument specified that determines the amount of
  shrinkage.}

\item{lambda}{can be either a scalar, in which case all the slope
coefficients are assigned this value, or alternatively, the user can
specify a vector of length equal to the number of linear covariates plus
one (for the intercept) and these values will be used as coordinate
dependent shrinkage factors.}

\item{contrasts}{a list giving contrasts for some or all of the factors
default = \code{NULL} appearing in the model formula. The elements of the
list should have the same name as the variable and should be either a
contrast matrix (specifically, any full-rank matrix with as many rows as
there are levels in the factor), or else a function to compute such a
matrix given the number of levels.}

\item{ztol}{A zero tolerance parameter used to determine the number of
zero residuals in the fitted object which in turn determines the effective
dimensionality of the fit.}

\item{control}{control argument for the fitting routines
(see \code{\link{sfn.control}}}

\item{...}{Other arguments passed to fitting routines}
}
\value{
The function returns a fitted object representing the estimated
model specified in the formula.  See \code{\link{rqss.object}}
for further details on this object, and references to methods
to look at it.
}
\description{
\code{rqss_new} is based on \code{\link{rqss}} function in
\code{\link{quantreg}} package. The main difference is that this new function
implements the weights option, which can be quite useful. It is used to fit
function for additive quantile regression models with possible univariate
and/or bivariate nonparametric terms estimated by total variation
regularization.
}
\details{
Total variation regularization for univariate and bivariate nonparametric
quantile smoothing is described in Koenker, Ng and Portnoy (1994) and Koenker
and Mizera(2003) respectively.  The additive model extension of this approach
depends crucially on the sparse linear algebra implementation for R described
in Koenker and Ng (2003).  There are extractor methods \code{\link{logLik}}
and \code{\link{AIC}} that is relevant to lambda selection.  A more detailed
description of some recent developments of these methods is available from
within the package with \code{vignette("rqss")}.  Since this function uses
sparse versions of the interior point algorithm it may also prove to be
useful for fitting linear models without \code{\link{qss}} terms when the
design has a sparse structure, as for example when there is a complicated
factor structure.

If the \pkg{MatrixModels} and \pkg{Matrix} packages are both loadable then
the linear in parameters portion of the design matrix is made in sparse
matrix form, this is helpful in large applications with many factor variables
for which dense formation of the design matrix would take too much space.
}
\examples{
One<-one[sample(1:2999,2000),]
tau<-0.5
fit0<-rqss(y ~ qss(x, lambda = 1), tau = tau, data = One)


x0<-seq(2.3,5.1,length=200)
response<-rep(NA,200)
extrapolated <- x0 > max(One$x) | x0 < min(One$x)
response[!extrapolated] = predict(fit0, newdata = data.frame(x=x0[!extrapolated]))

plot(One,col="grey",pch=20,main="Implement Weights in rqss()")
lines(x0,response,lty=2,lwd=3)


times<-sample(1:30,2000,replace=TRUE)
index<-rep(1:2000,times=times)
One_new<-One[index,]
fit_rep<-rqss(y ~ qss(x, lambda = 1), tau = tau, data = One_new)

response1<-rep(NA,200)
extrapolated <- x0 > max(One_new$x) | x0 < min(One_new$x)
response1[!extrapolated] = predict(fit_rep, newdata = data.frame(x=x0[!extrapolated]))

lines(x0,response1,col="red",lwd=2)
legend("topright",lty=c(2,1),lwd=c(3,2),col=c("black","red"),legend=c("Original Data","Repeated Data"))
}
\references{
Koenker, R. and S. Portnoy (1997)
The Gaussian Hare and the Laplacean
Tortoise:  Computability of Squared-error vs Absolute Error Estimators,
(with discussion).
\emph{Statistical Science} \bold{12}, 279--300.

Koenker, R., P. Ng and S. Portnoy, (1994)
Quantile Smoothing Splines;
\emph{Biometrika} \bold{81}, 673--680.

Koenker, R. and I. Mizera, (2003)
Penalized Triograms: Total Variation Regularization for Bivariate Smoothing;
\emph{JRSS(B)} \bold{66}, 145--163.

Koenker, R. and P. Ng (2003)
SparseM:  A Sparse Linear Algebra Package for R,
\emph{J. Stat. Software}.

Esmond G. Ng and Barry W. Peyton, "Block sparse Cholesky algorithms
on advanced uniprocessor computers". SIAM J. Sci. Stat. Comput.
14  (1993), pp. 1034-1056.

John R. Gilbert, Esmond G. Ng, and Barry W. Peyton, "An efficient
algorithm to compute row and column counts for sparse Cholesky
factorization". SIAM J. Matrix Anal. Appl. 15 (1994), pp. 1075-1091.
}
\seealso{
\code{\link{rqss}}, \code{\link{qss}}
}
\author{
Roger Koenker, Modified by Likun Zhang
}
\keyword{regression,}
\keyword{robust}
\keyword{smooth,}
