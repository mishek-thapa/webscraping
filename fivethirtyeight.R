
library(tidyverse)
library(rvest)
library(robotstxt)


webpage <- read_html("http://projects.fivethirtyeight.com/redistricting-maps/north-carolina/")

#democratic gap is negative, republican is postive
efficiency <- webpage %>%
  html_nodes(".table-column:nth-child(1) .name+ td") %>%
  html_text() %>%
  str_replace("\\%", "") %>%
  str_replace("D\\+", "-") %>%
  str_replace("R\\+", "") %>%
  as.numeric()
efficiency_name <- webpage %>%
  html_nodes(".table-column:nth-child(1) .rank-row .name") %>%
  html_text()
nc_efficiency <- tibble(
  test = "efficiency",
  value = efficiency,
  name = efficiency_name,
  rank = 1:8
)

#quantity of competitive districts
competitive <- webpage %>%
  html_nodes(".table-column:nth-child(2) .name+ td") %>%
  html_text() %>%
  as.numeric()
competitive_name <- webpage %>%
  html_nodes(".table-column:nth-child(2) .rank-row .name") %>%
  html_text()
nc_competitive <- tibble(
  test = "competitive",
  value = competitive,
  name = competitive_name,
  rank = 1:8
)

#quantiy of majority non-white districts
nonwhite <- webpage %>%
  html_nodes(".table-column:nth-child(3) .name+ td") %>%
  html_text() %>%
  as.numeric()
nonwhite_name <- webpage %>%
  html_nodes(".table-column:nth-child(3) .rank-row .name") %>%
  html_text()
nc_nonwhite <- tibble(
  test = "nonwhite",
  value = nonwhite,
  name = nonwhite_name,
  rank = 1:8
)

#county rankings
county <- webpage %>%
  html_nodes(".table-column:nth-child(4) .name+ td") %>%
  html_text() %>%
  as.numeric()
county_name <- webpage %>%
  html_nodes(".table-column:nth-child(4) .rank-row .name") %>%
  html_text()
nc_county <- tibble(
  test  = "county",
  value = county,
  name = county_name,
  rank = 1:8
)

#compactness rankings 
compactness <- webpage %>%
  html_nodes(".table-column:nth-child(5) .name+ td") %>%
  html_text() %>%
  as.numeric()
compactness_name <- webpage %>%
  html_nodes(".table-column:nth-child(5) .rank-row .name") %>%
  html_text()
nc_compactness <- tibble(
  test = "compactness",
  value = compactness,
  name = compactness_name,
  rank = 1:8
)

nc_data <- full_join(nc_compactness, nc_competitive) %>%
  full_join(., nc_county) %>%
  full_join(., nc_efficiency) %>%
  full_join(., nc_nonwhite)
  
  