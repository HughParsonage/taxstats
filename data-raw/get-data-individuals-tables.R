library(httr)
library(readxl)
library(dplyr)
library(magrittr)
library(zoo)

# Individuals Table 12
if (!file.exists("inst/extdata//Individuals-Table-12.xlsx")){
GET("http://data.gov.au/dataset/25e81c18-2083-4abe-81b6-0f530053c63f/resource/4878bd4b-a03f-4133-9cdc-a4a2bf9be375/download/Taxstats2014Individual12ResidencyTaxableStatusTaxableIncome.xlsx", write_disk("inst/extdata//Individuals-Table-12.xlsx"))
}

indiv_by_taxable_status_residency_taxable_income_range <- 
  read_excel("inst/extdata/Individuals-Table-12.xlsx", sheet = 2, na = "na", skip = 2)

variable_cols <- names(indiv_by_taxable_status_residency_tax_bracket)[1:3]
value_cols <- names(indiv_by_taxable_status_residency_tax_bracket)[-c(1:3)]

devtools::use_data(indiv_by_taxable_status_residency_taxable_income_range)
