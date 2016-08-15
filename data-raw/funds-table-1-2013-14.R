library(httr)
library(readxl)
library(dplyr)
library(data.table)
library(dtplyr)
library(tidyr)
library(magrittr)
library(tidyr)
library(zoo)
library(grattan)

temp <- tempfile(fileext = ".xlsx")
GET(url = "http://data.gov.au/dataset/25e81c18-2083-4abe-81b6-0f530053c63f/resource/15981dd2-ed4a-44e4-8def-0ccfc0ef8090/download/taxstats2014fund1apraselecteditemsbyyear.xlsx", 
    write_disk(path = temp))

funds_table1_201314 <- 
  
  read_excel(temp, sheet = 2, skip = 2, na = "na") %>%
  as.data.table %>%
  setnames(1, "Selected items") %>%
  setnames(2, "unit") %>%
  # .absent signifies where unit is blank which appears to correspond to
  # selected items that are no longer 'on the form'. See xlsx file, sheet 1.
  # We use n() to ensure that every column at spread() is unique
  # Superheadings are in `Selected items but have a blank before them
  mutate(Superheading = ifelse(is.na(lag(`Selected items`, default = "")) & is.na(unit), 
                               `Selected items`, 
                               NA_character_), 
         Superheading = na.locf(Superheading, na.rm = FALSE), 
         Superheading = ifelse(is.na(Superheading), "National counts", Superheading)) %>% 
  # ncol(.) - 2L because Superheading is guaranteed to be non-NA (Selected items)
  filter(rowSums(is.na(.)) < ncol(.) - 2L) %>%
  group_by(`Selected items`) %>%
  mutate(unit = ifelse(is.na(unit), paste0(".absent", 1:n()),
                       ifelse(unit == "no.", "Count", 
                              ifelse(unit == "$", "Sum", "unknown")))) %>% 
  gather(fy_year, value, -`Selected items`, -Superheading, -unit, factor_key = TRUE) %>%
  data.table %>% 
  spread(unit, value) %>% 
  # fy_year are inconsisently coded. N.B. 1999-00 is coded as 1999-2000
  mutate(fy_year = yr2fy(as.numeric(gsub("^([12][0-9]{3})[^0-9](([0-9]{2})|(2000))$", "\\1", fy_year)) + 1)) %>%
  # the .absent columns don't add much
  select(-contains("absent")) %>%
  select(Superheading, Selected_items = `Selected items`, fy_year, Count, Sum)

devtools::use_data(funds_table1_201314)
