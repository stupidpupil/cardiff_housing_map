library(tidyverse)

read_csv("data-raw/287841034.csv", skip=8, n_max=1077) %>%
  rename(OA11Code = `2011 output area`) %>%
  mutate(
    ProportionPrivateRented = `Private rented: Total`/`All categories: Tenure`,
    ProportionSocialRented  = (`Social rented: Rented from council (Local Authority)` + `Social rented: Other social rented`)/`All categories: Tenure`
  ) %>% select(OA11Code, ProportionPrivateRented, ProportionSocialRented) %>%
  write_csv("data/tenure.csv")