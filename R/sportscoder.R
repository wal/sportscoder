#' @title Analyse Hudl SportsCode data in R
#'
#' @description Load SportsCode XML Edit file into a tibble for analysis
#' @param path Path to SportsCode XML file
#' @param format Choose either long, tidy or matrix Format
#' "Long Format" returns a data frame with a row per code & label group combination
#' "Tidy Format" returns a data frame with a single row per code instance (tag) and corresponding labels as columns
#' "Matrix" is a summary format returning a single row per code, with counts of corresponding labels (Based on the sportscode matrix)
#' @return A data.frame
#' @examples
#' read_sportscode_xml('Sportscode-edit-file.xml')
#' read_sportscode_xml('Sportscode-edit-file.xml', 'long')
#' read_sportscode_xml('Sportscode-edit-file.xml', 'tidy')
#' read_sportscode_xml('Sportscode-edit-file.xml', 'matrix')

library(tidyverse)
library(xml2)
library(reshape2)

#' @export
read_sportscode_xml <- function(sportscode_xml_file_path, format = "long") {

  instances <- read_xml(sportscode_xml_file_path) %>% xml_find_all(".//instance")

  df <- instances %>% map_df(function(instance) {
    instance_id <- xml_child(instance, 'ID') %>% xml_text() %>% as.numeric()
    instance_start <- xml_child(instance, 'start') %>% xml_text() %>% as.numeric()
    instance_end <- xml_child(instance, 'end') %>% xml_text() %>% as.numeric()
    instance_code <- xml_child(instance, 'code') %>% xml_text()

    instance_labels_groups <- instance %>% xml_find_all(".//label/group") %>% xml_text()
    instance_labels_text <- instance %>% xml_find_all(".//label/text") %>% xml_text()

    labels_df = data_frame(group = instance_labels_groups, text = instance_labels_text)
    labels_df <- unique(labels_df)

    data_frame(id = instance_id,
               start =instance_start,
               end = instance_end,
               code = instance_code,
               label_group = labels_df$group,
               label_text = labels_df$text)
  })

  df$code <- factor(df$code)
  df$label_group <- factor(df$label_group)
  df$label_text <- factor(df$label_text)

  if(format == "long") {
    return(df)
  } else if(format == "tidy") {
    return(df %>% dcast(id + start + end + code ~ label_group, value.var = "label_text"))
  } else if (format == "matrix") {
    return(df %>% dcast(code ~ paste(label_group, " : ", label_text), value.var = "label_text", length))
  } else if (format == "matrix_group") {
    return(df %>% dcast(code ~ label_group, value.var = "label_text", length))
  } else {
    stop(paste("ERROR: Unknown format: ", format))
  }
}
