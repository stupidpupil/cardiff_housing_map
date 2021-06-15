library(tidyverse)

readxl::read_xlsx("data-raw/WIMD 2019 Indicator data by lower super output area.xlsx", range="Housing!A3:G1913") %>%
  mutate(
    LSOA11Code = `Lower Level Super Output Areas`, 
    LikelihoodHousingHazard = `Likelihood of housing containing serious hazards (%)`/100,
    LikelihoodHousingDisrepair = `Likelihood of housing being in disrepair (%)`/100) %>%
  select(LSOA11Code, LikelihoodHousingHazard, LikelihoodHousingDisrepair) %>%
  write_csv("data/wimd2019_housing.csv")