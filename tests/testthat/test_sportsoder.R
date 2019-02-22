library(stringr)
context("String length")

test_that("format returns correct dimensions", {
  data <- read_sportscode_xml("fixtures/XML Edit list.xml")
  expect_equal(dim(data), c(557,17))
})
