library(tidyverse)
library(sf)

oa_boundaries <- st_read("data-raw/Output_Areas__December_2011__Boundaries_EW_BGC.geojson")
cardiff_oas <- read_csv("data-raw/cardiff_oas.csv")

cardiff_oa_boundaries <- oa_boundaries %>% 
  filter(OA11CD %in% cardiff_oas$OA11Code)

cardiff_oa_boundaries %>% rename(OA11Code = OA11CD) %>% 
  left_join(cardiff_oas) %>% select(OA11Code, LSOA11Code) %>%
  st_write("data/cardiff_oa_boundaries.geojson")