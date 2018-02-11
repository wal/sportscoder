![](https://static.hudl.com/craft/logos/logo-sportscode.png?mtime=20160303123643)

# sportscoder
A library for loading Hudl SportsCode data into an R data frame for analysis

## Installation

```r
$ devtools::install_github("wal/sportscoder")
```

## Usage

The library loads data from a standard SportsCode XML file.

```r
$ library(sportscoder)
dt <- read_sportscode_xml(PATH_TO_XML, FORMAT)
```

The Library supports 4 formats (examples below and in ```examples/examples.R```)

| Format | Description |
| --- | --- |
| Long Format | A row per combination of code, label group and label |
| Tidy Format | A row per code, with columns representing label groups and cells representing label text  |
| Matrix Format | A row per tag, with columns representing label groups and cells representing counts of labels associated with that tag  |
| Matrix Group Format | A row per tag and label group combination and cells representing the count of labels (of that group) associated with that tag.  |


## Formats

### Long Format

Long form returns a row per combination of code, label group and label. Therefore a single code will appear multiple times once per labal group / label combination .. 

e.g

```r
$ long_format_dt <- read_sportscode_xml("examples/XML Edit list.xml", format = "long")
$ long_format_dt %>% head()
# A tibble: 6 x 6
     id start   end code            label_group    label_text   
  <dbl> <dbl> <dbl> <fct>           <fct>          <fct>        
1  5.00   353   371 Team-B Turnover Quarter        Q1           
2  5.00   353   371 Team-B Turnover TO Location    TO Defense 50
3  6.00   353   363 Team-B Aerial   Quarter        Q1           
4  6.00   353   363 Team-B Aerial   Aerial Outcome Successful   
5  9.00   366   376 Team-A Aerial   Quarter        Q1           
6  9.00   366   376 Team-A Aerial   Aerial Outcome Successful   
```


### Tidy Format

Tidy form returns a single row per code, with columns representing label groups and cells representing label text

e.g

```r
$ tidy_format_dt <- read_sportscode_xml("examples/XML Edit list.xml", format = "tidy")
$ tidy_format_dt %>% head()
  id    start      end            code Aerial Outcome Attack Entry GSO PCA Momentum Quarter   TO Location
1  5 352.8362 370.8362 Team-B Turnover           <NA>         <NA> <NA>         <NA>        Q1 TO Defense 50
2  6 353.4367 363.4367   Team-B Aerial     Successful         <NA> <NA>         <NA>        Q1          <NA>
3  9 366.3970 376.3970   Team-A Aerial     Successful         <NA> <NA>         <NA>        Q1          <NA>
4 10 367.6360 379.5566      Team-A A25           <NA>         Left <NA>         <NA>        Q1          <NA>
5 11 371.5566 389.5566 Team-A Turnover           <NA>         <NA> <NA>         <NA>        Q1  TO Attack 25
6 15 390.6778 400.6778   Team-B Aerial     Successful         <NA> <NA>         <NA>        Q1          <NA>

```

### Matrix Format

Matrix form returns a format similar to the SportsCode Matrix. One row per tag, with columns representing label groups and cells representing counts of labels associated with that tag

```r
$ matrix_format_dt <- read_sportscode_xml("examples/XML Edit list.xml", format = "matrix")

# Subsetting for readability
$ matrix_format_dt %>% select(code, `Aerial Outcome  :  Successful`, `GSO  :  On Target`, `Circle Pen  :  Left`, `Circle Pen  :  Centre`, `Circle Pen  :  Right`) %>% head()
           code Aerial Outcome  :  Successful GSO  :  On Target Circle Pen  :  Left Circle Pen  :  Centre Circle Pen  :  Right
1 GOAL MOMENTUM                             0                 0                   0                     0                    0
2   PC MOMENTUM                             0                 0                   0                     0                    0
3    Team-A A25                             2                 0                   0                     0                    1
4 Team-A Aerial                            10                 0                   0                     0                    0
5   Team-A Card                             0                 0                   0                     0                    0
6     Team-A CP                             0                 0                   8                     7                    8
```

### Matrix Group Format

Matrix Group format returns a summarised Matrix format where each row representes a tag and label group combination and cells representing the count of labels (of that group) associated with that tag.

```r
$ matrix_group_format_dt <- read_sportscode_xml("examples/XML Edit list.xml", format = "matrix_group")
$ matrix_group_format_dt %>% head()
           code Aerial Outcome Attack Entry CARD Circle Pen CP Outcome Goal Number GSO PCA Momentum PCA Number Quarter TO Location TO Outcome
1 GOAL MOMENTUM              0            0    0          0          0           6   0            0          0       0           0          0
2   PC MOMENTUM              0            0    0          0          0           0   0            7          7       0           0          0
3    Team-A A25              2           33    0          1          1           0   0            0          0      34           0          0
4 Team-A Aerial             14            0    0          0          1           0   0            0          0      14           0          0
5   Team-A Card              0            0    1          0          0           0   0            0          0       2           0          0
6     Team-A CP              0            0    0         23          7           0   1            0          0      23           0          0
```
