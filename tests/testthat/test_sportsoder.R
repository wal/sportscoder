library(stringr)
context("String length")

test_that("long format returns correct dimensions", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "long")
  expect_equal(dim(data), c(802,6))
})

test_that("tidy format returns correct dimensions", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "tidy")
  expect_equal(dim(data), c(335,20))
})

test_that("matrix format returns correct dimensions", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "matrix")
  expect_equal(dim(data), c(23,17))
})

test_that("default format is long", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml", "long")
  expect_equal(dim(data), c(802,6))
})
