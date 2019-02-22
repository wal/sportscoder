![](https://static.hudl.com/craft/logos/logo-sportscode.png?mtime=20160303123643)

# sportscoder
An R library for loading Hudl SportsCode data into an R data frame for analysis

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

The returned data frame is in a tidy form with a single row per code, with columns representing label groups and cells representing label text

e.g

```r
$ dt <- read_sportscode_xml("examples/XML Edit list.xml")
$ dt %>% head()
  id    start      end            code Aerial Outcome Attack Entry GSO PCA Momentum Quarter   TO Location
1  5 352.8362 370.8362 Team-B Turnover           <NA>         <NA> <NA>         <NA>        Q1 TO Defense 50
2  6 353.4367 363.4367   Team-B Aerial     Successful         <NA> <NA>         <NA>        Q1          <NA>
3  9 366.3970 376.3970   Team-A Aerial     Successful         <NA> <NA>         <NA>        Q1          <NA>
4 10 367.6360 379.5566      Team-A A25           <NA>         Left <NA>         <NA>        Q1          <NA>
5 11 371.5566 389.5566 Team-A Turnover           <NA>         <NA> <NA>         <NA>        Q1  TO Attack 25
6 15 390.6778 400.6778   Team-B Aerial     Successful         <NA> <NA>         <NA>        Q1          <NA>

```
