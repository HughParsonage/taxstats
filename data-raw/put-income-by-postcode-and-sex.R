library(dplyr)
library(data.table)
library(readxl)

income_by_postcode_sex_1314 <- 
  read_excel("./data-raw/income-by-postcode-and-sex.xlsx", sheet = "data") %>%
  select(-6) #empty

devtools::use_data(income_by_postcode_sex_1314)
