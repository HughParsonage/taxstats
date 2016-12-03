library(httr)
library(readxl)
library(dplyr)
library(dtplyr)
library(magrittr)
library(zoo)
library(data.table)

# Individuals Table 12
if (!file.exists("inst/extdata//Individuals-Table-12.xlsx")){
GET("http://data.gov.au/dataset/25e81c18-2083-4abe-81b6-0f530053c63f/resource/4878bd4b-a03f-4133-9cdc-a4a2bf9be375/download/Taxstats2014Individual12ResidencyTaxableStatusTaxableIncome.xlsx", write_disk("inst/extdata//Individuals-Table-12.xlsx"))
}

indiv_by_taxable_status_residency_tax_bracket <- 
  read_excel("inst/extdata/Individuals-Table-12.xlsx", sheet = 2, na = "na", skip = 2) %>%
  as.data.table 



id_cols <- names(indiv_by_taxable_status_residency_tax_bracket)[1:3]
value_cols <- names(indiv_by_taxable_status_residency_tax_bracket)[-c(1:3)]

indiv_by_taxable_status_residency_taxable_income_range <- 
  indiv_by_taxable_status_residency_tax_bracket %>%
  .[,which(!duplicated(names(.))),with=FALSE] %>%
  # setnames(old = names(.), new = gsub("[^A-Za-z$.]", "XX", names(.))) %>%
  melt.data.table(id.vars = id_cols)

indiv_by_taxable_status_residency_taxable_income_range <- 
  indiv_by_taxable_status_residency_taxable_income_range %>%
  mutate(variable = gsub("[^A-Za-z$. ]", "", variable)) %>%
  mutate(unit = if_else(grepl("[$]$", variable), "dollar", "number")) %>%
  mutate(variable = gsub("((no\\.)|[$])$", "", variable)) %>%
  setnames(old = names(.), new = gsub(" ", "_", names(.), fixed = TRUE)) %>%
  mutate(Residency_status = gsub("Non.resident", "Non-resident", trimws(Residency_status))) %>%
  # ASCII forcing:
  as.data.table %>%
  .[ , (1:3) := lapply(.SD, function(x) iconv(x, to = "ASCII")), .SDcols = 1:3] 

devtools::use_data(indiv_by_taxable_status_residency_taxable_income_range, overwrite = TRUE)
