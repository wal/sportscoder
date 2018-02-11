library(sportscoder)

# Long format
long_format_dt <- read_sportscode_xml("examples/XML Edit list.xml", format = "long")
long_format_dt %>% head()


# tidy format
tidy_format_dt <- read_sportscode_xml("examples/XML Edit list.xml", format = "tidy")
tidy_format_dt %>% head()


# Matrix format
matrix_format_dt <- read_sportscode_xml("examples/XML Edit list.xml", format = "matrix")
# Subsetting for readability
matrix_format_dt %>% select(code, `Aerial Outcome  :  Successful`, `GSO  :  On Target`, `Circle Pen  :  Left`, `Circle Pen  :  Centre`, `Circle Pen  :  Right`) %>% head()


# Matrix group format
matrix_group_format_dt <- read_sportscode_xml("examples/XML Edit list.xml", format = "matrix_group")
matrix_group_format_dt %>% head()
