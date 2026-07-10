#' Build the caribou study area
#'
#' Fetch the Yukon caribou herd ranges from GeoYukon (via
#' [ytdata::yt_get_caribou_herds()]), keep the herds in `herd_class`, dissolve
#' them, reproject to `crs`, and apply an outward buffer. The default is the
#' Northern Mountain Complex (the 26 Yukon herds with
#' `HERD_CLASS == "Northern Mountain"`).
#'
#' This is a runnable placeholder for a project-supplied study-area polygon.
#'
#' @param herd_class Character vector of GeoYukon `HERD_CLASS` values to keep.
#' @param buffer_m Outward buffer applied to the dissolved range, in metres.
#' @param crs Target CRS, in any form accepted by [terra::project()].
#'
#' @return A single-feature terra `SpatVector` in `crs`.
#' @export
#' @examples
#' \dontrun{
#' build_study_area()
#' }
build_study_area <- function(
  herd_class = "Northern Mountain",
  buffer_m = 20000,
  crs = "EPSG:3978"
) {
  herds <- ytdata::yt_get_caribou_herds(quiet = TRUE)
  herds <- herds[herds$HERD_CLASS %in% herd_class, ]
  if (nrow(herds) == 0L) {
    stop("No caribou herds matched HERD_CLASS: ", paste(herd_class, collapse = ", "))
  }
  v <- terra::project(terra::vect(herds), crs)
  terra::buffer(terra::aggregate(v), width = buffer_m)
}

#' Build a template raster (`rasterToMatch`) over a study area
#'
#' @param study_area A terra `SpatVector` (e.g. from [build_study_area()]).
#' @param res_m Pixel size in metres.
#'
#' @return A terra `SpatRaster` with value 1 inside `study_area`, `NA` outside.
#' @export
#' @examples
#' \dontrun{
#' build_rasterToMatch(build_study_area(), res_m = 250)
#' }
build_rasterToMatch <- function(study_area, res_m = 250) {
  template <- terra::rast(
    terra::ext(study_area),
    resolution = res_m,
    crs = terra::crs(study_area)
  )
  rtm <- terra::rasterize(study_area, template, field = 1L)
  names(rtm) <- "rasterToMatch"
  rtm
}

#' Build the larger scfm calibration study area
#'
#' The convex hull of the buffered study area, used by scfm to fit fire-regime
#' parameters over a larger extent than the simulation study area.
#'
#' @param study_area A terra `SpatVector`.
#' @param buffer_m Outward buffer (metres) applied before taking the convex hull.
#'
#' @return A terra `SpatVector` convex hull.
#' @export
#' @examples
#' \dontrun{
#' build_study_area_calibration(build_study_area())
#' }
build_study_area_calibration <- function(study_area, buffer_m = 50000) {
  terra::convHull(terra::buffer(study_area, width = buffer_m))
}

#' Build the parameterisation study area (a larger buffered study area)
#'
#' `Biomass_borealDataPrep` parameterises its statistical models over a larger
#' area than the simulation study area; this is `study_area` with an additional
#' outward buffer.
#'
#' @param study_area A terra `SpatVector` (see [build_study_area()]).
#' @param buffer_m Additional outward buffer, in metres.
#'
#' @return A terra `SpatVector`.
#' @export
#' @examples
#' \dontrun{
#' build_study_area_param(build_study_area())
#' }
build_study_area_param <- function(study_area, buffer_m = 50000) {
  terra::buffer(study_area, width = buffer_m)
}
