library(readxl)
library(data.table)

mean_taxable_income_by_postcode_200607 <-
  as.data.table(read_excel("data-raw/mean-taxable-income-by-postcode-2006-07.xlsx", col_types = c("text", "numeric")))
    
devtools::use_data(mean_taxable_income_by_postcode_200607)


