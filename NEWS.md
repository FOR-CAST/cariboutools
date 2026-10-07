# cariboutools 0.0.0.9001

* `build_rasterToMatch()` snaps the extent outward to whole `res_m` cells on a grid with its origin at (0, 0). It used to stretch the cells to fit the study area's extent, so templates built from different study areas did not line up, and scfm stopped with "resolution does not match".

# cariboutools 0.0.0.9000

* Initial version.
* `build_study_area()` builds the (dissolved, buffered) caribou study area from the GeoYukon herd ranges (via ytdata); default is the Northern Mountain Complex.
* `build_rasterToMatch()` builds a template raster over a study area, and `build_study_area_calibration()` builds the larger convex-hull calibration area for scfm.
