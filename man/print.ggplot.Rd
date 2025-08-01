% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{print.ggplot}
\alias{print.ggplot}
\alias{print.ggplot2::ggplot}
\alias{plot.ggplot2::ggplot}
\title{Explicitly draw plot}
\usage{
\method{print}{`ggplot2::ggplot`}(x, newpage = is.null(vp), vp = NULL, ...)
}
\arguments{
\item{x}{plot to display}

\item{newpage}{draw new (empty) page first?}

\item{vp}{viewport to draw plot in}

\item{...}{other arguments not used by this method}
}
\value{
Invisibly returns the original plot.
}
\description{
Generally, you do not need to print or plot a ggplot2 plot explicitly: the
default top-level print method will do it for you. You will, however, need
to call \code{print()} explicitly if you want to draw a plot inside a
function or for loop.
}
\examples{
colours <- c("class", "drv", "fl")

# Doesn't seem to do anything!
for (colour in colours) {
  ggplot(mpg, aes(displ, hwy, colour = .data[[colour]])) +
    geom_point()
}

for (colour in colours) {
  print(ggplot(mpg, aes(displ, hwy, colour = .data[[colour]])) +
          geom_point())
}
}
\keyword{hplot}
