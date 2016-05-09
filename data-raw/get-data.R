library(httr)
library(readxl)
library(dplyr)
library(magrittr)
library(zoo)  # na.locf

if (!file.exists("./data-raw/Samplefilesall.zip")){
  dir.create("data-raw", showWarnings = FALSE)
  GET(url = "http://data.gov.au/dataset/62ae540b-01b0-4c2e-a984-b8013884f1ec/resource/6ca75bab-96a6-4852-897c-1c0784d2fec9/download/Allyearssamplefile.zip",
      write_disk("./data-raw/Samplefilesall.zip", overwrite = TRUE))
}
unzip("./data-raw/Samplefilesall.zip", exdir = "data-raw")
for (filename in list.files(pattern = "^Sample", path = "data-raw", full.names = TRUE)){
  unzip(filename, exdir = "data-raw")
}

read_taxstats <- function(filename){
  data.table::fread(filename, na.strings = c("NA", "", "?"))
}

taxstats <- lapply(list.files(pattern = "file.*txt$", 
                              path = "data-raw", 
                              recursive = TRUE,
                              full.names = TRUE), 
                   read_taxstats)


# metadata
tempf <- paste0(tempfile(), ".xlsx")
GET(url = "http://data.gov.au/dataset/e29ef9ca-0d1a-47ec-9e9b-14a79a941511/resource/07087862-134c-4804-99cc-da8e3a6cfdcb/download/taxstats2013samplefile2013.xlsx",
    write_disk(tempf))

sample_file_variable_names <- 
  read_excel(tempf, sheet = 1) %>%
  .[1:6] %>%
  filter(!is.na(No.))

devtools::use_data(sample_file_variable_names)

age_range_decoder <- 
  readr::read_tsv("age_range	age_range_description
0	70 and over
1	65 to 69
2	60 to 64
3	55 to 59
4	50 to 54
5	45 to 49
6	40 to 44
7	35 to 39
8	30 to 34
9	25 to 29
10	20 to 24
11	under 20
") %>%
  arrange(desc(age_range)) %>%
  mutate(age_range_description = factor(age_range_description, 
                                        levels = unique(.$age_range_description), 
                                        ordered = TRUE))

devtools::use_data(age_range_decoder, overwrite = TRUE)

occupation_decoder <- 
  readr::read_tsv("Occ_code\tOccupation_description
0	Occupation not listed/ Occupation not specified
                  1	Managers
                  2	Professionals
                  3	Technicians and Trades Workers
                  4	Community and Personal Service Workers
                  5	Clerical and Administrative Workers
                  6	Sales workers
                  7	Machinery operators and drivers
                  8	Labourers
                  9	Consultants, apprentices and type not specified or not listed")

devtools::use_data(occupation_decoder)

region_decoder <- 
  readr::read_tsv("Region	Region_description
0	ACT major urban - capital city
                  1	NSW major urban - capital city
                  2	NSW other urban
                  3	NSW regional - high urbanisation
                  4	NSW regional - low urbanisation
                  5	NSW rural
                  6	NT major urban - capital city
                  7	NT regional - high urbanisation
                  8	NT regional - low urbanisation
                  9	QLD major urban - capital city
                  10	QLD other urban
                  11	QLD regional - high urbanisation
                  12	QLD regional - low urbanisation
                  13	QLD rural
                  14	SA major urban - capital city
                  15	SA regional - high urbanisation
                  16	SA regional - low urbanisation
                  17	SA rural
                  18	TAS major urban - capital city
                  19	TAS other urban
                  20	TAS regional - high urbanisation
                  21	TAS regional - low urbanisation
                  22	Tas rural
                  23	VIC major urban - capital city
                  24	VIC other urban
                  25	VIC regional - high urbanisation
                  26	VIC regional - low urbanisation
                  27	VIC rural
                  28	WA major urban - capital city
                  29	WA other urban
                  30	WA regional - high urbanisation
                  31	WA regional - low urbanisation
                  32	WA rural
                  34	NSW other
                  35	WA other")

devtools::use_data(region_decoder)
