library(readxl)
library(openxlsx)
library(dplyr)
library(readr)
library(tidyr)

stopifnot(file.exists("data-raw/2013-14/Documentation/Benchmarking for sample file 2013-14.xlsx"))

# 2013-14
# col_names_201314 <- 
#   readWorkbook("data-raw/2013-14/Documentation/Benchmarking for sample file 2013-14.xlsx", rows = 1:2, colNames = FALSE, sheet = "Values")
# 
# # dumb but effective 
# # trickier because the 'vectors' run across columns.
# for (j in 1:ncol(col_names_201314)){
#   if (is.na(col_names_201314[1, j])){
#     col_names_201314[1, j] <- col_names_201314[1, j - 1] 
#   }
# }
# 
# new_col_names_201314 <- character(ncol(col_names_201314))
# 
# for (k in seq_along(new_col_names_201314)){
#   if (is.na(col_names_201314[2, k])){
#     new_col_names_201314[k] <- col_names_201314[1, k]
#   } else {
#     new_col_names_201314[k] <- paste(col_names_201314[1, k], col_names_201314[2, k])
#   }
# }
# ...f dis

# a naughty ATO officer has entered `n.a.` not `na`!
cleanse_n.a. <- function(x){
  if (is.numeric(x)){
    return(x)
  } else {
    x <- ifelse(x == "n.a.", NA, x)
    as.numeric(x)
  }
}

benchmarking_201314_orig <- 
  read_excel("data-raw/2013-14/Documentation/Benchmarking for sample file 2013-14.xlsx", 
             sheet = 2, 
             na = "na", 
             skip = 2, 
             col_names = FALSE) %>%
  grattan:::select_which_(Which = function(x) !all(is.na(x))) %>%
  setNames(nm = c("data_item", "description", 
                  "count_actual", "sum_actual", 
                  "count_available_for_sample", "sum_available_for_selection", 
                  "count_sample", "sum_sample", 
                  "count_sample_over_actual", "sum_sample_over_actual")) %>%
  mutate_each(funs(cleanse_n.a.), -data_item, -description)

devtools::use_data(benchmarking_201314_orig)



