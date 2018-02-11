library(stringr)
context("String length")

test_that("long format returns correct dimensions", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "long")
  expect_equal(dim(data), c(611,6))
})

test_that("default format is long", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "long")
  expect_equal(dim(data), c(611,6))
})

test_that("tidy format returns correct dimensions", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "tidy")
  expect_equal(dim(data), c(295,16))
})

test_that("matrix format returns correct dimensions", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "matrix")
  expect_equal(dim(data), c(22,37))
})

test_that("matrix format returns correct dimensions", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "matrix_group")
  expect_equal(dim(data), c(22,13))
})

test_that("errors when unknown format passed", {
  expect_error(read_sportscode_xml("fixtures/XML Edit list.xml", "invalid-format"))
})
