#' Transformed Cartesian coordinate system
#'
#' `coord_transform()` is different to scale transformations in that it occurs after
#' statistical transformation and will affect the visual appearance of geoms - there is
#' no guarantee that straight lines will continue to be straight.
#'
#' Transformations only work with continuous values: see
#' [scales::new_transform()] for list of transformations, and instructions
#' on how to create your own.
#'
#' The `coord_trans()` function is deprecated in favour of `coord_transform()`.
#'
#' @inheritParams coord_cartesian
#' @param x,y Transformers for x and y axes or their names.
#' @param limx,limy `r lifecycle::badge("deprecated")` use `xlim` and `ylim` instead.
#' @param ... Arguments forwarded to `coord_transform()`.
#' @seealso
#' The `r link_book("coord transformations section", "coord#transformations-with-coord_trans")`
#' @export
#' @examples
#' \donttest{
#' # See ?geom_boxplot for other examples
#'
#' # Three ways of doing transformation in ggplot:
#' #  * by transforming the data
#' ggplot(diamonds, aes(log10(carat), log10(price))) +
#'   geom_point()
#' #  * by transforming the scales
#' ggplot(diamonds, aes(carat, price)) +
#'   geom_point() +
#'   scale_x_log10() +
#'   scale_y_log10()
#' #  * by transforming the coordinate system:
#' ggplot(diamonds, aes(carat, price)) +
#'   geom_point() +
#'   coord_transform(x = "log10", y = "log10")
#'
#' # The difference between transforming the scales and
#' # transforming the coordinate system is that scale
#' # transformation occurs BEFORE statistics, and coordinate
#' # transformation afterwards.  Coordinate transformation also
#' # changes the shape of geoms:
#'
#' d <- subset(diamonds, carat > 0.5)
#'
#' ggplot(d, aes(carat, price)) +
#'   geom_point() +
#'   geom_smooth(method = "lm") +
#'   scale_x_log10() +
#'   scale_y_log10()
#'
#' ggplot(d, aes(carat, price)) +
#'   geom_point() +
#'   geom_smooth(method = "lm") +
#'   coord_transform(x = "log10", y = "log10")
#'
#' # Here I used a subset of diamonds so that the smoothed line didn't
#' # drop below zero, which obviously causes problems on the log-transformed
#' # scale
#'
#' # With a combination of scale and coordinate transformation, it's
#' # possible to do back-transformations:
#' ggplot(diamonds, aes(carat, price)) +
#'   geom_point() +
#'   geom_smooth(method = "lm") +
#'   scale_x_log10() +
#'   scale_y_log10() +
#'   coord_transform(x = scales::transform_exp(10), y = scales::transform_exp(10))
#'
#' # cf.
#' ggplot(diamonds, aes(carat, price)) +
#'   geom_point() +
#'   geom_smooth(method = "lm")
#'
#' # Also works with discrete scales
#' set.seed(1)
#' df <- data.frame(a = abs(rnorm(26)),letters)
#' plot <- ggplot(df,aes(a,letters)) + geom_point()
#'
#' plot + coord_transform(x = "log10")
#' plot + coord_transform(x = "sqrt")
#' }
coord_transform <- function(x = "identity", y = "identity", xlim = NULL, ylim = NULL,
                            limx = deprecated(), limy = deprecated(), clip = "on",
                            expand = TRUE, reverse = "none") {
  if (lifecycle::is_present(limx)) {
    deprecate_warn0("3.3.0", "coord_transform(limx)", "coord_transform(xlim)")
    xlim <- limx
  }
  if (lifecycle::is_present(limy)) {
    deprecate_warn0("3.3.0", "coord_transform(limy)", "coord_transform(ylim)")
    ylim <- limy
  }

  check_coord_limits(xlim)
  check_coord_limits(ylim)

  # resolve transformers
  if (is.character(x)) x <- as.transform(x)
  if (is.character(y)) y <- as.transform(y)

  ggproto(
    NULL, CoordTransform,
    trans = list(x = x, y = y),
    limits = list(x = xlim, y = ylim),
    expand = expand,
    reverse = reverse,
    clip = clip
  )
}

#' @rdname coord_transform
#' @export
coord_trans <- function(...) {
  deprecate_soft0(
    "4.0.0",
    "coord_trans()",
    "coord_transform()"
  )
  coord_transform(...)
}

#' @rdname Coord
#' @format NULL
#' @usage NULL
#' @export
CoordTransform <- ggproto(
  "CoordTransform", Coord,

  is_free = function() {
    TRUE
  },

  distance = function(self, x, y, panel_params) {
    max_dist <- dist_euclidean(panel_params$x.range, panel_params$y.range)
    dist_euclidean(self$trans$x$transform(x), self$trans$y$transform(y)) / max_dist
  },

  backtransform_range = function(self, panel_params) {
    list(
      x = self$trans$x$inverse(panel_params$x.range),
      y = self$trans$y$inverse(panel_params$y.range)
    )
  },

  range = function(self, panel_params) {
    list(
      x = panel_params$x.range,
      y = panel_params$y.range
    )
  },

  transform = function(self, data, panel_params) {
    # trans_x() and trans_y() needs to keep Inf values because this can be called
    # in guide_transform.axis()
    reverse <- panel_params$reverse %||% "none"
    x_range <- switch(reverse, xy = , x = rev, identity)(panel_params$x.range)
    y_range <- switch(reverse, xy = , y = rev, identity)(panel_params$y.range)
    trans_x <- function(data) {
      idx <- !is.infinite(data)
      data[idx] <- transform_value(self$trans$x, data[idx], x_range)
      data
    }
    trans_y <- function(data) {
      idx <- !is.infinite(data)
      data[idx] <- transform_value(self$trans$y, data[idx], y_range)
      data
    }

    new_data <- transform_position(data, trans_x, trans_y)

    warn_new_infinites(data$x, new_data$x, "x")
    warn_new_infinites(data$y, new_data$y, "y")

    transform_position(new_data, squish_infinite, squish_infinite)
  },

  setup_panel_params = function(self, scale_x, scale_y, params = list()) {
    c(
      view_scales_from_scale_with_coord_trans(scale_x, self$limits$x, self$trans$x, params$expand[c(4, 2)]),
      view_scales_from_scale_with_coord_trans(scale_y, self$limits$y, self$trans$y, params$expand[c(3, 1)]),
      reverse = self$reverse %||% "none"
    )
  },

  render_bg = function(self, panel_params, theme) {
    guide_grid(theme, panel_params, self)
  },

  render_axis_h = function(panel_params, theme) {
    list(
      top = panel_guides_grob(panel_params$guides, position = "top", theme = theme),
      bottom = panel_guides_grob(panel_params$guides, position = "bottom", theme = theme)
    )
  },

  render_axis_v = function(panel_params, theme) {
    list(
      left = panel_guides_grob(panel_params$guides, position = "left", theme = theme),
      right = panel_guides_grob(panel_params$guides, position = "right", theme = theme)
    )
  }
)

# TODO: deprecate this some time in the future
#' @rdname Coord
#' @format NULL
#' @usage NULL
#' @export
CoordTrans <- ggproto("CoordTrans", CoordTransform)

transform_value <- function(trans, value, range) {
  if (is.null(value))
    return(value)
  rescale(trans$transform(value), 0:1, range)
}

# TODO: can we merge this with view_scales_from_scale()?
view_scales_from_scale_with_coord_trans <- function(scale, coord_limits, trans, expand = TRUE) {
  expansion <- default_expansion(scale, expand = expand)
  transformation <- scale$get_transformation() %||% transform_identity()
  coord_limits <- coord_limits %||% transformation$inverse(c(NA, NA))
  scale_limits <- scale$get_limits()

  if (scale$is_discrete()) {
    continuous_ranges <- expand_limits_discrete_trans(
      scale$map(scale_limits),
      expansion,
      coord_limits,
      trans,
      range_continuous = scale$range_c$range
    )
  } else {
    # transform user-specified limits to scale transformed space
    coord_limits <- transformation$transform(coord_limits)
    continuous_ranges <- expand_limits_continuous_trans(
      scale_limits,
      expansion,
      coord_limits,
      trans
    )
  }

  # calculate break information
  out <- scale$break_info(continuous_ranges$continuous_range)

  # range in coord space has already been calculated
  # needs to be in increasing order for transform_value() to work
  out$range <- range(continuous_ranges$continuous_range_coord)

  # major and minor values in coordinate data
  out$major_source <- transform_value(trans, out$major_source, out$range)
  out$minor_source <- transform_value(trans, out$minor_source, out$range)
  out$sec.major_source <- transform_value(trans, out$sec.major_source, out$range)
  out$sec.minor_source <- transform_value(trans, out$sec.minor_source, out$range)

  out <- list(
    # Note that a ViewScale requires a limit and a range that are before the
    # Coord's transformation, so we pass `continuous_range`, not `continuous_range_coord`.
    view_scale_primary(scale, scale_limits, continuous_ranges$continuous_range),
    sec = view_scale_secondary(scale, scale_limits, continuous_ranges$continuous_range),
    range = out$range,
    labels = out$labels,
    major = out$major_source,
    minor = out$minor_source,
    sec.labels = out$sec.labels,
    sec.major = out$sec.major_source,
    sec.minor = out$sec.minor_source
  )

  aesthetic <- scale$aesthetics[1]
  names(out) <- c(aesthetic, paste(aesthetic, names(out)[-1], sep = "."))
  out
}

#' Generate warning when finite values are transformed into infinite values
#'
#' @param old_values A vector of pre-transformation values.
#' @param new_values A vector of post-transformation values.
#' @param axis Which axis the values originate from (e.g. x, y).
#' @noRd
warn_new_infinites <- function(old_values, new_values, axis, call = caller_env()) {
  if (any(is.finite(old_values) & !is.finite(new_values))) {
    cli::cli_warn("Transformation introduced infinite values in {axis}-axis", call = call)
  }
}

