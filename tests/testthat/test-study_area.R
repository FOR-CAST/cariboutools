test_that("build_rasterToMatch makes a template raster over the study area", {
  sa <- terra::vect("POLYGON ((0 0, 10000 0, 10000 10000, 0 10000, 0 0))", crs = "EPSG:3978")
  rtm <- build_rasterToMatch(sa, res_m = 250)
  expect_s4_class(rtm, "SpatRaster")
  expect_equal(terra::res(rtm), c(250, 250))
  expect_equal(terra::crs(rtm, describe = TRUE)$code, "3978")
  expect_equal(names(rtm), "rasterToMatch")
})

test_that("build_rasterToMatch snaps to whole cells on a shared grid", {
  sa <- terra::vect("POLYGON ((13 7, 10101 7, 10101 9893, 13 9893, 13 7))", crs = "EPSG:3978")
  rtm <- build_rasterToMatch(sa, res_m = 250)
  expect_equal(terra::res(rtm), c(250, 250))
  expect_equal(as.vector(terra::ext(rtm)), c(xmin = 0, xmax = 10250, ymin = 0, ymax = 10000))
  rtm_large <- build_rasterToMatch(terra::buffer(sa, 3333), res_m = 250)
  expect_no_error(terra::compareGeom(rtm, rtm_large, ext = FALSE, rowcol = FALSE, res = TRUE))
})

test_that("build_study_area_calibration returns a larger convex hull", {
  sa <- terra::vect("POLYGON ((0 0, 10000 0, 10000 10000, 0 10000, 0 0))", crs = "EPSG:3978")
  sac <- build_study_area_calibration(sa, buffer_m = 5000)
  expect_s4_class(sac, "SpatVector")
  expect_gt(terra::expanse(sac), terra::expanse(sa))
})

test_that("build_study_area_param buffers outward", {
  sa <- terra::vect("POLYGON ((0 0, 10000 0, 10000 10000, 0 10000, 0 0))", crs = "EPSG:3978")
  p <- build_study_area_param(sa, buffer_m = 5000)
  expect_s4_class(p, "SpatVector")
  expect_gt(terra::expanse(p), terra::expanse(sa))
})

test_that("build_study_area fetches and buffers the caribou range", {
  skip_on_cran()
  skip_if_offline("mapservices.gov.yk.ca")

  ## live GeoYukon service: skip (do not fail) if it is transiently unavailable
  sa <- tryCatch(
    build_study_area(buffer_m = 20000, crs = "EPSG:3978"),
    error = function(e) skip(paste("GeoYukon unavailable:", conditionMessage(e)))
  )
  expect_s4_class(sa, "SpatVector")
  expect_equal(nrow(sa), 1L)
  expect_equal(terra::crs(sa, describe = TRUE)$code, "3978")
})
