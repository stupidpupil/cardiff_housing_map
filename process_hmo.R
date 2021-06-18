
hmos <- readxl::read_xls("data-raw/L02 and L05 unique 30 March 2017(1).xls")
hmos <- hmos %>% rename(Postcode = postcode) %>% add_fields_based_on_postcode(fields=c("OA11Code"))

normalize_manager_name = function(x){
  x %>%
  str_replace_all("[^\\w\\s\\-]","") %>%
  str_replace_all(regex("(Ltd|Plc|LLP)", ignore_case=TRUE), "") %>%
  str_replace_all(regex("Limited", ignore_case=TRUE), "")
}

hmos <- hmos %>% mutate(
  manager = case_when(
    !is.na(alternative.manager) ~ alternative.manager,
    TRUE ~ licence.holder
  ) %>% normalize_manager_name
)

hmos %>% 
  group_by(OA11Code, manager) %>% count() %>%
  arrange(OA11Code, -n) %>%
  group_by(OA11Code) %>%
  summarise(CountOfHMOs = sum(n), HMOManagers=paste0(manager %>% head(5), collapse=", ")) %>%
  write_csv("data/hmo_count.csv")