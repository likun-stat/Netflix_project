% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Bootstrap_rqss_2dim.R
\name{Bootstrap_rqss_2dim}
\alias{Bootstrap_rqss_2dim}
\title{Regular Bootstrap Method.}
\usage{
Bootstrap_rqss_2dim(cores = NULL, data = parent.frame(), alpha = 0.05,
  tau = 0.25, lambda = 2, B = 100, D = 50, x0 = NULL, Search = TRUE)
}
\arguments{
\item{cores}{The number of cores to use for parallel execution. If not
specified, the number of cores is set to the value of
\code{options("cores")}, if specified, or to one-half the number of cores
detected by the \code{\link{parallel}} package.}

\item{data}{A 3-dim optional data frame (or object coercible by
\code{\link{as.data.frame}} to a data frame) containing the variables in
the model. The column names should be specified in a way that “x1” and "x2"
are for the two predictors respectively, and “y” for the response.}

\item{alpha}{The confidence level required. The default is 0.05.}

\item{tau}{A specific quantile to be estimated. Must be a number between 0
and 1.}

\item{lambda}{The smoothing parameter governing the tradeoff between fidelity
and the penalty component for the triogram term. If \code{Search=TRUE},
there is no need for users to specify a value.}

\item{B}{The number of Monte Carlo iterations using bootstrap with
replacement. \eqn{B=100} is by default.}

\item{D}{A number that determines the density of a grid of x values over
which pointwise confidence intervals will be computed. If specified,  a
\eqn{D×D} grid of equidistant points on the plane is created.}

\item{Search}{If \code{TRUE} (which is recommended), then the function will
first search for an optimum smoothing parameter \eqn{\lambda}.}
}
\value{
A list with two parts: \code{x0} and \code{CIs}, where \code{x0}
  contains the x values that we are examining the confidence intervals at,
  and \code{CIs} is 2-dim matrix which contains the corresponding lower bound
  and upper bound.
}
\description{
\code{Bootstrap_rqss_2dim}  Regualr bootstrap for data sets with 2-dim
covariate. Used to generate the confidence bands for a quantile smoothing
splines fitted with the rqss function from package \code{\link{quantreg}}.
}
\details{
This function is based on a regular bootstrap method, which calculates
confidence bands for one quantile. It performs parallelization to speed up
the calculation.
}
\examples{
data(two)
result<-Bootstrap_rqss_2dim(data=two, alpha=0.05, tau=0.5,B=100,Search=TRUE)

#1. 3D plot
plot<-FitPlot_2dim(data=two, result=result, xlab='x', ylab='y', zlab='z')
plot

#2. Contour plot
#Plot the confidence bands
library(akima)
valid<-!is.na(result$CI_average[,1])
X<-result$x0$x1[valid];Y<-result$x0$x2[valid]
lower<-result$CI_average[valid,1]; upper<-result$CI_average[valid,2]
x1range<-range(X);x2range<-range(Y)
akima1<-interp(X,Y,lower,xo=seq(x1range[1],x1range[2],length=200),yo=seq(x2range[1],x2range[2],length=200))
akima2<-interp(X,Y,upper,xo=seq(x1range[1],x1range[2],length=200),yo=seq(x2range[1],x2range[2],length=200))

plot(X,Y,main="Prediction Contour Plot",type="n",xlab="x1",ylab="x2")
image(akima1,add=TRUE,col = terrain.colors(12))  ###YOU CAN CHANGE THE NUMBER OF COLOR LEVELS!!!!
contour(akima1,add=TRUE,nlevels=12)

}
\references{
Micheal, I. J et al.(2012). \eqn{A Scalable Bootstrap for Massive
  Data}.

Roger Koenker.(2005). \eqn{Quantile regression}. Cambridge
  university press.
}
\seealso{
\code{\link{BLB_rqss_2dim}} for BLB with 2-dim covariate data set.

\code{\link{Bootstrap_rqss}} for regular Bootstrap method with
  1-dim covariate data set
}
