#' Default Yukon tree species
#'
#' A placeholder list of the tree species used to subset the LandR
#' species-equivalencies table for the Northern Mountain caribou study area,
#' as LandR species codes (the `LandR` column of
#' [LandR::sppEquivalencies_CA]). This is a documented default to keep the
#' preamble runnable; confirm/adjust with the project team (as for the study
#' area).
#'
#' @return A character vector of LandR species codes.
#' @export
#' @examples
#' yukon_tree_species()
yukon_tree_species <- function() {
  c(
    "Abie_las", # subalpine fir
    "Betu_pap", # white / paper birch
    "Lari_lar", # tamarack (eastern larch)
    "Pice_gla", # white spruce
    "Pice_mar", # black spruce
    "Pinu_con", # lodgepole pine
    "Popu_bal", # balsam poplar
    "Popu_tre" # trembling aspen
  )
}

#' Build the species-equivalencies table (`sppEquiv`)
#'
#' Subset [LandR::sppEquivalencies_CA] to the species of interest, matched on
#' `sppEquivCol`. The result is the `sppEquiv` object consumed by the
#' `Biomass_*` modules and by `LandR` plotting helpers.
#'
#' @param species Character vector of species codes to keep (values of the
#'   `sppEquivCol` column). Defaults to [yukon_tree_species()].
#' @param sppEquivCol Name of the [LandR::sppEquivalencies_CA] column that
#'   `species` refers to (and the column used downstream). Defaults to
#'   `"LandR"`.
#'
#' @return A `data.table` (a subset of [LandR::sppEquivalencies_CA]).
#' @export
#' @examples
#' \dontrun{
#' build_sppEquiv()
#' }
build_sppEquiv <- function(species = yukon_tree_species(), sppEquivCol = "LandR") {
  if (!requireNamespace("LandR", quietly = TRUE)) {
    stop("Package 'LandR' is required for build_sppEquiv().", call. = FALSE)
  }
  sppEquivalencies_CA <- NULL # nolint: keeps R CMD check quiet about the data promise
  utils::data("sppEquivalencies_CA", package = "LandR", envir = environment())
  se <- sppEquivalencies_CA
  if (!sppEquivCol %in% names(se)) {
    stop("sppEquivCol '", sppEquivCol, "' is not a column of LandR::sppEquivalencies_CA.")
  }
  se <- se[se[[sppEquivCol]] %in% species, ]
  if (nrow(se) == 0L) {
    stop("No species matched in column '", sppEquivCol, "': ", paste(species, collapse = ", "))
  }
  se
}

#' Build the species colour vector (`sppColorVect`)
#'
#' A named vector of plotting colours (one per species in `sppEquiv`, plus an
#' extra entry for mixed stands), via [LandR::sppColors()].
#'
#' @param sppEquiv A species-equivalencies table (see [build_sppEquiv()]).
#' @param sppEquivCol Name of the `sppEquiv` column giving the species codes to
#'   name the colours by. Defaults to `"LandR"`.
#' @param palette An RColorBrewer palette name passed to [LandR::sppColors()].
#'
#' @return A named character vector of hex colours.
#' @export
#' @examples
#' \dontrun{
#' build_sppColorVect(build_sppEquiv())
#' }
build_sppColorVect <- function(sppEquiv, sppEquivCol = "LandR", palette = "Accent") {
  if (!requireNamespace("LandR", quietly = TRUE)) {
    stop("Package 'LandR' is required for build_sppColorVect().", call. = FALSE)
  }
  LandR::sppColors(sppEquiv, sppEquivCol, newVals = "Mixed", palette = palette)
}
