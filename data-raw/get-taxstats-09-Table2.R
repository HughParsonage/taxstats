library(httr)
library(openxlsx)
library(tidyverse)
library(data.table)

# Obtain the 2009-10 taxstats
get_200910_and_bind_table3 <- function(showPowershellScript = FALSE, runPowershellScript = FALSE){
  orig_wd <- getwd()
  on.exit(setwd(orig_wd))
  setwd("./data-raw/data-gov-au-downloads")
  
  if (showPowershellScript){
    cat(readLines("ConvertXLS2XLSX.ps1"), sep = "\n")
    return(invisible(NULL))
  }
  
  GET("http://data.gov.au/dataset/75010df9-9cda-4a17-86d6-56e0e602119d/resource/b5849af2-07e5-42d1-9feb-05aee10afa2a/download/taxstats-200910.zip", 
      write_disk("Taxstats200910.zip", overwrite = FALSE))
  
  unzip("Taxstats200910.zip", exdir = file.path(".", "taxstats200910"))
  
  if (length(list.files(pattern = "xlsx$", path = file.path(".", "taxstats200910"))) == 0L){
    if (!runPowershellScript){
      stop("This function requires the unzipped file be .xlsx, not .xls.", "\n", 
           "Not your fault!", "\n", 
           "Please convert.", "\n", 
           "Clue: use the option 'showPowershellScript = TRUE' which will cat() a Powershell script.")
    } else {
      if (!any(grepl("WindowsPowerShell", Sys.getenv("PATH")))){
        stop("To run powershell, powershell must be on the path.")
      } else {
        message("Converting xls files to xlsx")
        system2("powershell", args = c("-file", "ConvertXLS2XLSX.ps1"))
      }
    }
  }
}

read_table_3_0910 <- function(filename){
  names <- 
    openxlsx::readWorkbook(filename, 
                           sheet = 2, 
                           rows = c(3, 4), 
                           colNames = FALSE) %>%
    t %>%
    as.data.frame %>%
    as.data.table %>%
    setnames(1:2, new = c("variable", "unit")) %>%
    mutate(variable = zoo::na.locf(variable, na.rm = FALSE)) %>%
    mutate(var = paste(gsub("[^A-Za-z]+", "_", gsub("[0-9]$", "", variable)), unit, sep = "_"))
  
  dat <- 
    openxlsx::readWorkbook(filename, 
                           sheet = 2, startRow = 5, colNames = FALSE, check.names = FALSE)
  
  names(dat) <- if_else(grepl("^Postcode", names$var), "Postcode", names$var)
  
  
  
  dat <-
    dat %>%
    as.data.table %>%
    melt.data.table(id.vars = "Postcode") %>%
    filter(!(Postcode %in% c("Other state/territories", "OS/not stated", "Total")))
  
  state <- unique(gsub(" Total", "", tail(dat$Postcode, 1), fixed = TRUE))
  
  dat %>%
    mutate(unit = gsub("^.*_(.*)$", "\\1", variable), 
           variable = gsub("^(.*[^_])_(.*)$", "\\1", variable), 
           State = state) %>%
    mutate(Postcode = suppressWarnings(as.numeric(Postcode))) %>%
    filter(!is.na(Postcode))

}


bound_xlsx_pattern <- function(path, pattern) {
  list.files(path = path, pattern = pattern, recursive = TRUE, full.names = TRUE) %>%
    lapply(read_table_3_0910) %>%
    rbindlist
}

individuals_table3_200910 <- 
  bound_xlsx_pattern(path = "./data-raw/data-gov-au-downloads/taxstats200910/TaxStats/docs/", pattern = "PER3[A-Z].xlsx$") 

devtools::use_data(individuals_table3_200910)


