test_that("yukon_tree_species returns LandR species codes", {
  spp <- yukon_tree_species()
  expect_type(spp, "character")
  expect_contains(spp, c("Pice_gla", "Pinu_con", "Popu_tre"))
})

test_that("build_sppEquiv subsets sppEquivalencies_CA to the requested species", {
  skip_if_not_installed("LandR")
  se <- build_sppEquiv(species = c("Pice_gla", "Pinu_con"))
  expect_s3_class(se, "data.table")
  expect_setequal(unique(se$LandR), c("Pice_gla", "Pinu_con"))
})

test_that("build_sppEquiv errors on an unknown sppEquivCol", {
  skip_if_not_installed("LandR")
  expect_snapshot(build_sppEquiv(sppEquivCol = "NotAColumn"), error = TRUE)
})

test_that("build_sppColorVect returns named hex colours with a Mixed entry", {
  skip_if_not_installed("LandR")
  se <- build_sppEquiv(species = c("Pice_gla", "Pinu_con"))
  cv <- build_sppColorVect(se)
  expect_named(cv, c("Pice_gla", "Pinu_con", "Mixed"))
  expect_match(cv, "^#", all = TRUE)
})
