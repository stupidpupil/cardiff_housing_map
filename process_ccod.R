ccod <- read_csv("data-raw/CCOD_FULL_2021_06.zip")
ccod <- ccod %>% filter(Postcode %>% str_detect('^CF'))


ccod <- ccod %>% add_fields_based_on_postcode(fields=c("OA11Code", "LocalAuthorityName")) %>%
  select(OA11Code, LocalAuthorityName, `Proprietor Name (1)`) %>%
  rename(Owner =  `Proprietor Name (1)`) %>%
  filter(LocalAuthorityName == 'Cardiff')

normalize_owner_name <- function(owner_name){
  owner_name %>%
    str_to_upper() %>%
    str_replace_all("LIMITED$", "") %>% str_trim() %>%
    str_replace_all("(LTD|PLC|LLP)$", "") %>% str_trim() %>%
    str_replace_all("\\(.+?\\)", "") %>% str_trim() %>%
    str_replace_all("\\bAND\\b", "&") %>% str_trim() %>%
    str_replace_all("\\s+", " ") %>% str_trim() %>%
    str_to_title() %>%
    str_replace_all("The County Council Of The City & County Of Cardiff", "Cardiff Council") %>%
    str_replace_all("The Council Of The City Of Cardiff", "Cardiff Council") %>%
    str_replace_all("`\\b(Uk)\\b", "UK") %>%
    str_replace_all("`\\b(Nhs)\\b", "NHS")
}


ccod <- ccod %>% mutate(Owner = Owner %>% normalize_owner_name())

ccod %>% group_by(OA11Code, Owner) %>% count %>% filter(n >= 3) %>%
  arrange(OA11Code, -n) %>%
  group_by(OA11Code) %>% 
  slice_head(n=3) %>%
  summarise(Owners=paste0(Owner, collapse=", ")) %>%
  write_csv("data/major_owners.csv")