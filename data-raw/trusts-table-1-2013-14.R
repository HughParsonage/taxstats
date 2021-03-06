library(readxl)
library(dplyr)
library(tidyr)
library(httr)
library(data.table)
library(zoo)
library(grattan)

if (!file.exists("./data-raw/Trusts_table1_2013-14.xlsx")){
  GET(url = "http://data.gov.au/dataset/25e81c18-2083-4abe-81b6-0f530053c63f/resource/18a9a051-22ec-4371-8a14-ef9cb0c0a16f/download/Taxstats2014trust1selecteditemsbyyear.xlsx", 
      write_disk("./data-raw/Trusts_table1_2013-14.xlsx"))
}

trusts_table1_201314 <- 
  
  read_excel("data-raw/Trusts_table1_2013-14.xlsx", sheet = 2, skip = 2, na = "na") %>% 
  # 2 is the unit: `no.` or `$`
  as.data.table %>%
  setnames(1, "Selected items") %>%
  setnames(2, "unit") %>%
  # .absent signifies where unit is blank which appears to correspond to
  # selected items that are no longer 'on the form'. See xlsx file, sheet 1.
  # We use n() to ensure that every column at spread() is unique
  # Superheadings are in `Selected items but have a blank before them
  mutate(Superheading = ifelse((is.na(lag(`Selected items`, default = "")) & is.na(unit)) | (`Selected items` == "Trusts records"), 
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
  as.data.table %>% 
  spread(unit, value) %>% 
  # fy_year are inconsisently coded. N.B. 1999-00 is coded as 1999-2000
  mutate(fy_year = yr2fy(as.numeric(gsub("^([12][0-9]{3})[^0-9](([0-9]{2})|(2000))$", "\\1", fy_year)) + 1)) %>%
  # the .absent columns don't add much
  {
    if (any(grepl("absent", names(.)))){
      select(., -contains("absent")) 
    } else {
      .
    }
  } %>%
  select(Superheading, Selected_items = `Selected items`, fy_year, Count, Sum) %>%
  # ASCII forcing:
  as.data.table %>%
  .[ , (1:3) := lapply(.SD, function(x) iconv(x, to = "ASCII")), .SDcols = 1:3] 

devtools::use_data(trusts_table1_201314, overwrite = TRUE)
