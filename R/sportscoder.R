library(tidyverse)
library(xml2)
library(reshape2)
library(furrr)
library(forcats)

plan(multiprocess)

#' @title Analyse Hudl SportsCode data in R
#'
#' @description Load SportsCode XML Edit file into a tibble for analysis
#' @param path Path to SportsCode XML file
#' @return A data.frame
#' @examples
#' read_sportscode_xml('Sportscode-edit-file.xml')
#' @export
read_sportscode_xml <- function(xml_file_path) {


  # Retrieve instances from XML
  instances <- read_xml(paste(rawToChar(read_file_raw(xml_file_path), multiple = TRUE), collapse = "")) %>% xml_find_all(".//instance")

  # Iterate over the instances from the xml and create a data_frame of one row per instance,
  df <- instances %>% future_map_dfr(function(instance) {

    instance_id <- xml_child(instance, 'ID') %>% xml_text() %>% as.numeric()
    instance_start <- xml_child(instance, 'start') %>% xml_text() %>% as.numeric()
    instance_end <- xml_child(instance, 'end') %>% xml_text() %>% as.numeric()
    instance_code <- xml_child(instance, 'code') %>% xml_text()

    # A data frame representing just this instance (will only have a single row)
    instance_df <- data_frame(id = instance_id,
                              code = instance_code,
                              start =instance_start,
                              end = instance_end,
                              other = NA)

    labels_with_a_group_nodes <- instance %>% xml_find_all("label[group]")

    # Add all labels with groups to a column in the dataframe. If multiple labels are present
    # they will be joined together into a single string (e.g Puckouts = "PO Won,Clean")

    if(length(labels_with_a_group_nodes) > 0) {

      # Convert labels into a data_frame
      labels_df <- labels_with_a_group_nodes %>% map_df(function(label_node) {
        group <- label_node %>% xml_find_first('group') %>% xml_text() %>% make.names()
        text <- label_node %>% xml_find_first('text') %>% xml_text() %>% head(1)
        data_frame(group, text)
      })


      labels_df <-
        labels_df %>%
        group_by(group) %>%
        summarise(labels = paste0(unique(text), collapse = ",")) %>%
        spread(group, labels)

      # bind the labels onto the instance data frame
      instance_df <- cbind(instance_df, labels_df)
    }


    # Add all labels without groups to a single column called other in the dataframe. If multiple labels are present
    # they will be joined together into a single string (e.g other = "Own Third,Opp Third,reset clock,Middle Third")
    labels_without_a_group_nodes <- instance %>% xml_find_all("label[not(group)]")

    if(length(labels_without_a_group_nodes) > 0) {

      labels_df <- labels_without_a_group_nodes %>% map_df(function(label_node) {
        group <- "other"
        text <- label_node %>% xml_find_first('text') %>% xml_text() %>% head(1)

        data_frame(group, text)
      })

      labels_df <-
        labels_df %>%
        group_by(group) %>%
        summarise(labels = paste0(unique(text), collapse = ",")) %>%
        spread(group, labels)

      # bind the labels onto the instance data frame
      instance_df <- cbind(instance_df, labels_df)
    }


    # The (single row) data frame representing just this instance
    instance_df
  })

 return(df %>% mutate_if(is.character, as.factor))
}
