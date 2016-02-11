library(httr)

dir.create("data-raw")
GET(url = "http://data.gov.au/dataset/62ae540b-01b0-4c2e-a984-b8013884f1ec/resource/6ca75bab-96a6-4852-897c-1c0784d2fec9/download/Samplefilesall.zip",
    write_disk("./data-raw/Samplefilesall.zip"))

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
