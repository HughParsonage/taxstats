library(readxl)
library(dplyr)
library(tidyr)
library(httr)
library(data.table)
library(zoo)
library(grattan)

file.copy("data-raw/2014-15/taxstats2015individual01selecteditemsbyyear.xlsx",
          "./data-raw/2014-15/Individuals_table1_2014-15.xlsx")

if (!file.exists("./data-raw/2014-15/Individuals_table1_2014-15.xlsx")){
  GET(url = "https://data.gov.au/dataset/5c99cfed-254d-40a6-af1c-47412b7de6fe/resource/b51ea9cc-4eac-4b25-b45a-175d7797c9d5/download/taxstats2015individual01selecteditemsbyyear.xlsx", 
      write_disk("./data-raw/Individuals_table1_2014-15.xlsx"))
}

individuals_table1_201415 <- 
  
  read_excel("data-raw/2014-15/Individuals_table1_2014-15.xlsx", sheet = 2, skip = 2, na = "na") %>% 
  # 2 is the unit: `no.` or `$`
  as.data.table %>%
  setnames(2L, "unit") %>%
  # .absent signifies where unit is blank which appears to correspond to
  # selected items that are no longer 'on the form'. See xlsx file, sheet 1.
  # We use n() to ensure that every column at spread() is unique
  # Superheadings are in `Selected items but have a blank before them
  mutate(Superheading = if_else(is.na(lag(`Selected items`, default = "")) & is.na(unit), 
                                `Selected items`, 
                                NA_character_), 
         Superheading = na.locf(Superheading, na.rm = FALSE), 
         Superheading = if_else(is.na(Superheading), "National counts", Superheading)) %>% 
  # ncol(.) - 2L because Superheading is guaranteed to be non-NA (Selected items)
  filter(rowSums(is.na(.)) < ncol(.) - 2L) %>%
  group_by(`Selected items`) %>%
  mutate(unit = if_else(is.na(unit), paste0(".absent", 1:n()),
                        if_else(unit == "no.", "Count", 
                                if_else(unit == "$", "Sum",
                                        "unknown")))) %>% 
  gather(fy_year, value, -`Selected items`, -Superheading, -unit, factor_key = TRUE) %>%
  as.data.table %>% 
  spread(unit, value) %>% 
  # fy_year are inconsisently coded. N.B. 1999-00 is coded as 1999-2000
  mutate(fy_year = yr2fy(as.numeric(gsub("^([12][0-9]{3})[^0-9](([0-9]{2})|(2000))$", "\\1", fy_year)) + 1)) %>%
  # the .absent columns don't add much
  select(-contains("absent")) %>%
  select(Superheading, Selected_items = `Selected items`, fy_year, Count, Sum) %>%
  as.data.table %>%
  .[ , (1:3) := lapply(.SD, function(x) iconv(x, to = "ASCII")), .SDcols = 1:3] %T>%
  fwrite("data-raw/2014-15/individuals_table1_201415.tsv", sep = "\t") %>%
  .[]

devtools::use_data(individuals_table1_201415, overwrite = TRUE)
