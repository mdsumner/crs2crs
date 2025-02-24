
test_that("crs_engine_null() works", {
  expect_s3_class(crs_engine_null(), "crs2crs_engine_null")
  expect_error(crs_engine_transform(crs_engine_null(), wk::xy(), crs_to = NULL), "can't transform")
})

test_that("crs_engine_identity() work", {
  expect_s3_class(crs_engine_identity(), "crs2crs_engine_identity")

  # crs equal
  expect_identical(
    crs_engine_transform(crs_engine_identity(), wk::xy(1, 1, crs = NULL), crs_to = NULL),
    wk::xy(1, 1, crs = NULL)
  )
  # crs inherit (from)
  expect_identical(
    crs_engine_transform(crs_engine_identity(), wk::xy(1, 1, crs = wk::wk_crs_inherit()), crs_to = NULL),
    wk::xy(1, 1, crs = NULL)
  )
  # crs inherit (to)
  expect_identical(
    crs_engine_transform(crs_engine_identity(), wk::xy(1, 1, crs = NULL), crs_to = wk::wk_crs_inherit()),
    wk::xy(1, 1, crs = NULL)
  )

  expect_message(
    expect_identical(
      crs_engine_transform(crs_engine_identity(), wk::xy(1, 1, crs = NULL), crs_to = "something"),
      wk::xy(1, 1, crs = "something")
    ),
    "Applying a dummy identity transform"
  )

  expect_silent(
    expect_identical(
      crs_engine_transform(crs_engine_identity(quiet = TRUE), wk::xy(1, 1, crs = NULL), crs_to = "something"),
      wk::xy(1, 1, crs = "something")
    )
  )
})

test_that("default set_longlat works", {
  obj <- wk::xy(1, 2, crs = NULL)
  eng <- crs_engine_null()
  expect_identical(crs_engine_set_longlat(eng, obj), wk::xy(1, 2, crs = "OGC:CRS84"))
  wk::wk_crs(obj) <- wk::wk_crs_inherit()
  expect_identical(crs_engine_set_longlat(eng, obj), wk::xy(1, 2, crs = "OGC:CRS84"))
  wk::wk_crs(obj) <- "NAD27"
  expect_identical(crs_engine_set_longlat(eng, obj), wk::xy(1, 2, crs = "OGC:CRS27"))
  wk::wk_crs(obj) <- "NAD83"
  expect_identical(crs_engine_set_longlat(eng, obj), wk::xy(1, 2, crs = "OGC:CRS83"))
  wk::wk_crs(obj) <- wk::wk_crs_inherit()
  expect_identical(crs_engine_set_longlat(eng, obj, datum = "NAD27"), wk::xy(1, 2, crs = "OGC:CRS27"))
})
