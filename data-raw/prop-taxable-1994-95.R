library(readxl)
library(magrittr)
library(data.table)
library(grattan)
library(hutils)
library(knitr)

aus_pop_1999 <- 
  aus_pop_qtr_age(tbl = TRUE, date = as.Date("1999-06-30")) %>%
  .[, .(Pop = sum(Value)),
    keyby = .(Age = cut(Age,
                        breaks = c(-Inf, 
                                   18, 
                                   seq(25, 75, by = 5) - 0.5,
                                   Inf),
                        labels = c("Under 18",
                                   "18 - 24",
                                   paste(seq(25, 70, by = 5), 
                                         "-",
                                         seq(25, 70, by = 5) + 4),
                                   "75 and over"),
                        include.lowest = TRUE))] %>%
  .[]

read_excel("data-raw/1998-99/taxstats-detailed-tables-1998-99/indiv02.xls", 
           range = c("A9:O113"),
           col_names = FALSE) %>%
  as.data.table %>%
  setnames(c(1L, 3L, ncol(.)), c("X", "NonTaxable", "Y")) %>%
  .[] %>%
  .[X == "Total" | grepl("[0-9]{2}", X)] %>%
  .[, .(X, NonTaxable, Y)] %>%
  .[, lapply(.SD, zoo::na.locf, na.rm = FALSE, fromLast = TRUE)] %>%
  .[] %>%
  .[X != "Total"] %>%
  setnames("Y", "Total") %>%
  setnames("X", "Age") %>%
  .[aus_pop_1999, on = "Age"] %>%
  .[, Prop := (Pop - NonTaxable) / Pop] %>%
  .[, Prop2 := Total / Pop] %>%
  .[]

read_excel("data-raw/1994-95/taxstats-detailed-tables-1994-95/C2.xls", 
           skip = 6,
           col_names = TRUE) %>%
  setnames(1:3, 
           c("Age", "Variable", "Unit")) %>%
  as.data.table %>%
  .[, Age := zoo::na.locf(Age, na.rm = FALSE)] %>%
  .[Variable %ein% "Total"] %>%
  .[Age %ein% "75 and Over", Age := "75 - 100"] %>%
  .[Age %ein% "Under 18", Age := "15 - 18"] %>%
  .[Age %enotin% c("Not Stated", "Total")] %>%
  .[order(Age)] %>%
  .[, Population := sum(aus_pop_qtr_age(date = as.Date("1994-03-01"),
                                        age = seq(as.integer(gsub("^([0-9]{2}) .*$",
                                                                  "\\1",
                                                                  .BY[["Age"]])),
                                                  as.integer(gsub("^([0-9]{2}) - ([0-9]+)$", 
                                                                  "\\2",
                                                                  .BY[["Age"]])), 
                                                  by = 1L))),
    by = "Age"] %>%
  setnames("Total Taxable", "TotTaxable") %>%
  .[, PropTaxable := TotTaxable / Population] %T>%
  fwrite("data-raw/1994-95/PropTaxable-vs-Age.tsv", sep = "\t") %>%
  .[, "% taxable" := paste0(formatC(round(100 * PropTaxable, 1),
                                    digits = 1,
                                    format = "f"), 
                            "%")] %T>%
  kable %>%
  .[]



