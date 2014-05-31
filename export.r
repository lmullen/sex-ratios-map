#!/usr/bin/env Rscript --vanilla

options(stringsAsFactors = FALSE)
library(dplyr)

data_county <- read.csv("data/nhgis0018_csv/nhgis0018_ts_county.csv")

export <- data_county %>%
  mutate(male = A08AA) %>%
  mutate(female = A08AB) %>%
  mutate(year = YEAR) %>%
  mutate(gisjoin = GISJOIN) %>%
  mutate(diff = male / (male + female) - 0.5) %>%
  mutate(diff = round(diff, 3)) %>%
  select(gisjoin, year, diff, male, female)

write.csv(export, "gender-census.csv")
