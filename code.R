library(readr)
library(tidyr)
library(dplyr)
library(leaflet)
library(magrittr)
library(zipcode)
library(USAboundaries)
data(zipcode)
zipcode

cities <- us_cities("2010-01-01")
us_zipcodes()

dat <- readr::read_csv("counts.csv")

dat <- tidyr::fill(dat, connection, .direction = "down")

dat <- dplyr::left_join(dat, zipcode, by = c("zipcode" = "zip"))

zip_totals <- dat %>%
  dplyr::group_by(zipcode) %>%
  dplyr::summarise(
    count = sum(count)
  )

zip_geo <- dplyr::left_join(zip_totals, zipcode, by = c("zipcode" = "zip"))

dplyr::left_join(zip_geo, cities, by = c("city" = "city", "state" = "state_abbr"))

total <- sum(zip_totals$count)
total


data("quakes")

leaflet(data = quakes[1:20, ]) %>%
  addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag), label = ~as.character(mag))


leaflet(data = zip_totals) %>%
  addTiles() %>%
  addCircleMarkers(~longitude,
             ~latitude,
             popup = ~as.character(count),
             label = ~as.character(count))
