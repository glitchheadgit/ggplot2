% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom-density.R, R/stat-density.R
\name{geom_density}
\alias{geom_density}
\alias{stat_density}
\title{Smoothed density estimates}
\usage{
geom_density(
  mapping = NULL,
  data = NULL,
  stat = "density",
  position = "identity",
  ...,
  outline.type = "upper",
  lineend = "butt",
  linejoin = "round",
  linemitre = 10,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

stat_density(
  mapping = NULL,
  data = NULL,
  geom = "area",
  position = "stack",
  ...,
  orientation = NA,
  bw = "nrd0",
  adjust = 1,
  kernel = "gaussian",
  n = 512,
  trim = FALSE,
  bounds = c(-Inf, Inf),
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by \code{\link[=aes]{aes()}}. If specified and
\code{inherit.aes = TRUE} (the default), it is combined with the default mapping
at the top level of the plot. You must supply \code{mapping} if there is no plot
mapping.}

\item{data}{The data to be displayed in this layer. There are three
options:

If \code{NULL}, the default, the data is inherited from the plot
data as specified in the call to \code{\link[=ggplot]{ggplot()}}.

A \code{data.frame}, or other object, will override the plot
data. All objects will be fortified to produce a data frame. See
\code{\link[=fortify]{fortify()}} for which variables will be created.

A \code{function} will be called with a single argument,
the plot data. The return value must be a \code{data.frame}, and
will be used as the layer data. A \code{function} can be created
from a \code{formula} (e.g. \code{~ head(.x, 10)}).}

\item{position}{A position adjustment to use on the data for this layer. This
can be used in various ways, including to prevent overplotting and
improving the display. The \code{position} argument accepts the following:
\itemize{
\item The result of calling a position function, such as \code{position_jitter()}.
This method allows for passing extra arguments to the position.
\item A string naming the position adjustment. To give the position as a
string, strip the function name of the \code{position_} prefix. For example,
to use \code{position_jitter()}, give the position as \code{"jitter"}.
\item For more information and other ways to specify the position, see the
\link[=layer_positions]{layer position} documentation.
}}

\item{...}{Other arguments passed on to \code{\link[=layer]{layer()}}'s \code{params} argument. These
arguments broadly fall into one of 4 categories below. Notably, further
arguments to the \code{position} argument, or aesthetics that are required
can \emph{not} be passed through \code{...}. Unknown arguments that are not part
of the 4 categories below are ignored.
\itemize{
\item Static aesthetics that are not mapped to a scale, but are at a fixed
value and apply to the layer as a whole. For example, \code{colour = "red"}
or \code{linewidth = 3}. The geom's documentation has an \strong{Aesthetics}
section that lists the available options. The 'required' aesthetics
cannot be passed on to the \code{params}. Please note that while passing
unmapped aesthetics as vectors is technically possible, the order and
required length is not guaranteed to be parallel to the input data.
\item When constructing a layer using
a \verb{stat_*()} function, the \code{...} argument can be used to pass on
parameters to the \code{geom} part of the layer. An example of this is
\code{stat_density(geom = "area", outline.type = "both")}. The geom's
documentation lists which parameters it can accept.
\item Inversely, when constructing a layer using a
\verb{geom_*()} function, the \code{...} argument can be used to pass on parameters
to the \code{stat} part of the layer. An example of this is
\code{geom_area(stat = "density", adjust = 0.5)}. The stat's documentation
lists which parameters it can accept.
\item The \code{key_glyph} argument of \code{\link[=layer]{layer()}} may also be passed on through
\code{...}. This can be one of the functions described as
\link[=draw_key]{key glyphs}, to change the display of the layer in the legend.
}}

\item{outline.type}{Type of the outline of the area; \code{"both"} draws both the
upper and lower lines, \code{"upper"}/\code{"lower"} draws the respective lines only.
\code{"full"} draws a closed polygon around the area.}

\item{lineend}{Line end style (round, butt, square).}

\item{linejoin}{Line join style (round, mitre, bevel).}

\item{linemitre}{Line mitre limit (number greater than 1).}

\item{na.rm}{If \code{FALSE}, the default, missing values are removed with
a warning. If \code{TRUE}, missing values are silently removed.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.
It can also be a named logical vector to finely select the aesthetics to
display. To include legend keys for all levels, even
when no data exists, use \code{TRUE}.  If \code{NA}, all levels are shown in legend,
but unobserved levels are omitted.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link[=annotation_borders]{annotation_borders()}}.}

\item{geom, stat}{Use to override the default connection between
\code{geom_density()} and \code{stat_density()}. For more information about
overriding these connections, see how the \link[=layer_stats]{stat} and
\link[=layer_geoms]{geom} arguments work.}

\item{orientation}{The orientation of the layer. The default (\code{NA})
automatically determines the orientation from the aesthetic mapping. In the
rare event that this fails it can be given explicitly by setting \code{orientation}
to either \code{"x"} or \code{"y"}. See the \emph{Orientation} section for more detail.}

\item{bw}{The smoothing bandwidth to be used.
If numeric, the standard deviation of the smoothing kernel.
If character, a rule to choose the bandwidth, as listed in
\code{\link[stats:bandwidth]{stats::bw.nrd()}}. Note that automatic calculation of the bandwidth does
not take weights into account.}

\item{adjust}{A multiplicate bandwidth adjustment. This makes it possible
to adjust the bandwidth while still using the a bandwidth estimator.
For example, \code{adjust = 1/2} means use half of the default bandwidth.}

\item{kernel}{Kernel. See list of available kernels in \code{\link[=density]{density()}}.}

\item{n}{number of equally spaced points at which the density is to be
estimated, should be a power of two, see \code{\link[=density]{density()}} for
details}

\item{trim}{If \code{FALSE}, the default, each density is computed on the
full range of the data. If \code{TRUE}, each density is computed over the
range of that group: this typically means the estimated x values will
not line-up, and hence you won't be able to stack density values.
This parameter only matters if you are displaying multiple densities in
one plot or if you are manually adjusting the scale limits.}

\item{bounds}{Known lower and upper bounds for estimated data. Default
\code{c(-Inf, Inf)} means that there are no (finite) bounds. If any bound is
finite, boundary effect of default density estimation will be corrected by
reflecting tails outside \code{bounds} around their closest edge. Data points
outside of bounds are removed with a warning.}
}
\description{
Computes and draws kernel density estimate, which is a smoothed version of
the histogram. This is a useful alternative to the histogram for continuous
data that comes from an underlying smooth distribution.
}
\section{Orientation}{

This geom treats each axis differently and, thus, can thus have two orientations. Often the orientation is easy to deduce from a combination of the given mappings and the types of positional scales in use. Thus, ggplot2 will by default try to guess which orientation the layer should have. Under rare circumstances, the orientation is ambiguous and guessing may fail. In that case the orientation can be specified directly using the \code{orientation} parameter, which can be either \code{"x"} or \code{"y"}. The value gives the axis that the geom should run along, \code{"x"} being the default orientation you would expect for the geom.
}

\section{Computed variables}{

These are calculated by the 'stat' part of layers and can be accessed with \link[=aes_eval]{delayed evaluation}.
\itemize{
\item \code{after_stat(density)}\cr density estimate.
\item \code{after_stat(count)}\cr density * number of points - useful for stacked density plots.
\item \code{after_stat(wdensity)}\cr density * sum of weights. In absence of weights, the same as \code{count}.
\item \code{after_stat(scaled)}\cr density estimate, scaled to maximum of 1.
\item \code{after_stat(n)}\cr number of points.
\item \code{after_stat(ndensity)}\cr alias for \code{scaled}, to mirror the syntax of \code{\link[=stat_bin]{stat_bin()}}.
}
}

\examples{
ggplot(diamonds, aes(carat)) +
  geom_density()
# Map the values to y to flip the orientation
ggplot(diamonds, aes(y = carat)) +
  geom_density()

ggplot(diamonds, aes(carat)) +
  geom_density(adjust = 1/5)
ggplot(diamonds, aes(carat)) +
  geom_density(adjust = 5)

ggplot(diamonds, aes(depth, colour = cut)) +
  geom_density() +
  xlim(55, 70)
ggplot(diamonds, aes(depth, fill = cut, colour = cut)) +
  geom_density(alpha = 0.1) +
  xlim(55, 70)

# Use `bounds` to adjust computation for known data limits
big_diamonds <- diamonds[diamonds$carat >= 1, ]
ggplot(big_diamonds, aes(carat)) +
  geom_density(color = 'red') +
  geom_density(bounds = c(1, Inf), color = 'blue')

\donttest{
# Stacked density plots: if you want to create a stacked density plot, you
# probably want to 'count' (density * n) variable instead of the default
# density

# Loses marginal densities
ggplot(diamonds, aes(carat, fill = cut)) +
  geom_density(position = "stack")
# Preserves marginal densities
ggplot(diamonds, aes(carat, after_stat(count), fill = cut)) +
  geom_density(position = "stack")

# You can use position="fill" to produce a conditional density estimate
ggplot(diamonds, aes(carat, after_stat(count), fill = cut)) +
  geom_density(position = "fill")
}
}
\seealso{
See \code{\link[=geom_histogram]{geom_histogram()}}, \code{\link[=geom_freqpoly]{geom_freqpoly()}} for
other methods of displaying continuous distribution.
See \code{\link[=geom_violin]{geom_violin()}} for a compact density display.
}
\section{Aesthetics}{

\code{geom_density()} understands the following aesthetics. Required aesthetics are displayed in bold and defaults are displayed for optional aesthetics:
\tabular{rll}{
 • \tab \strong{\code{\link[=aes_position]{x}}} \tab   \cr
 • \tab \strong{\code{\link[=aes_position]{y}}} \tab   \cr
 • \tab \code{\link[=aes_colour_fill_alpha]{alpha}} \tab → \code{NA} \cr
 • \tab \code{\link[=aes_colour_fill_alpha]{colour}} \tab → via \code{theme()} \cr
 • \tab \code{\link[=aes_colour_fill_alpha]{fill}} \tab → via \code{theme()} \cr
 • \tab \code{\link[=aes_group_order]{group}} \tab → inferred \cr
 • \tab \code{\link[=aes_linetype_size_shape]{linetype}} \tab → via \code{theme()} \cr
 • \tab \code{\link[=aes_linetype_size_shape]{linewidth}} \tab → via \code{theme()} \cr
 • \tab \code{weight} \tab → \code{1} \cr
}

Learn more about setting these aesthetics in \code{vignette("ggplot2-specs")}.
}
