library(taxstats)
library(grattan)
library(magrittr)

sample_file_1213 %>%
  # ABS: 166,027 million
  project_to(to_fy = "2013-14") %$%
  abs(sum(income_tax(Taxable_Income, "2013-14") * WEIGHT)/ (166027 * 1e6) - 1) < 0.025

sample_file_1213 %>%
  project_to(to_fy = "2014-15") %$%
  abs(sum(income_tax(Taxable_Income, "2014-15") * WEIGHT) / )
  

sample_file_1213 %$%
  sum(income_tax(Taxable_Income)) * 50