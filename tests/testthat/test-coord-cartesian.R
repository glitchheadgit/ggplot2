test_that("clipping can be turned off and on", {
  # clip on by default
  p <- ggplot() + coord_cartesian()
  coord <- ggplot_build(p)@layout$coord
  expect_equal(coord$clip, "on")

  # clip can be turned on and off
  p <- ggplot() + coord_cartesian(clip = "off")
  coord <- ggplot_build(p)@layout$coord
  expect_equal(coord$clip, "off")

  p <- ggplot() + coord_cartesian(clip = "on")
  coord <- ggplot_build(p)@layout$coord
  expect_equal(coord$clip, "on")
})

test_that("cartesian coords throws error when limits are badly specified", {
  # throws error when limit is a Scale object instead of vector
  expect_snapshot_error(ggplot() + coord_cartesian(xlim(1,1)))

  # throws error when limit's length is different than two
  expect_snapshot_error(ggplot() + coord_cartesian(ylim=1:3))
})

test_that("cartesian coords can be reversed", {
  p <- ggplot(data_frame0(x = c(0, 2), y = c(0, 2))) +
    aes(x = x, y = y) +
    geom_point() +
    coord_cartesian(
      xlim = c(-1, 3), ylim = c(-1, 3), expand = FALSE,
      reverse = "xy"
    ) +
    theme_test() +
    theme(axis.line = element_line())
  expect_doppelganger("reversed cartesian coords", p)
})


# Visual tests ------------------------------------------------------------

test_that("cartesian coords draws correctly with limits", {
  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()

  expect_doppelganger("expand range",
    p + coord_cartesian(xlim = c(0, 10), ylim = c(0, 50))
  )
  expect_doppelganger("contract range",
    p + coord_cartesian(xlim = c(2, 4), ylim = c(20, 40))
  )
})

test_that("cartesian coords draws correctly with clipping on or off", {
  df.in <- data_frame(label = c("inside", "inside", "inside", "inside"),
                      x = c(0, 1, 0.5, 0.5),
                      y = c(0.5, 0.5, 0, 1),
                      angle = c(90, 270, 0, 0),
                      hjust = c(0.5, 0.5, 0.5, 0.5),
                      vjust = c(1.1, 1.1, -0.1, 1.1))

  df.out <- data_frame(label = c("outside", "outside", "outside", "outside"),
                       x = c(0, 1, 0.5, 0.5),
                       y = c(0.5, 0.5, 0, 1),
                       angle = c(90, 270, 0, 0),
                       hjust = c(0.5, 0.5, 0.5, 0.5),
                       vjust = c(-0.1, -0.1, 1.1, -0.1))

  p <- ggplot(mapping = aes(x, y, label = label, angle = angle, hjust = hjust, vjust = vjust)) +
    geom_text(data = df.in) +
    geom_text(data = df.out) +
    scale_x_continuous(breaks = NULL, name = NULL) +
    scale_y_continuous(breaks = NULL, name = NULL) +
    theme(plot.margin = margin(20, 20, 20, 20),
          panel.spacing = grid::unit(10, "pt"))

  expect_doppelganger("clip on by default, only 'inside' visible",
    p + coord_cartesian(xlim = c(0, 1), ylim = c(0, 1), expand = FALSE)
  )

  expect_doppelganger("clip turned off, both 'inside' and 'outside' visible",
    p + coord_cartesian(xlim = c(0, 1), ylim = c(0, 1), expand = FALSE, clip = "off")
  )
})
