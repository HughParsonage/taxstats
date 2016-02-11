#'

.get_sample_file <- function(year = 2013){
  prev_yr <- substr(as.character(year - 1), 3, 4)
  yr <- substr(as.character(year), 3, 4)
  directory <- list.dirs(path = file.path("data-raw", paste0("Sample_file_", prev_yr, yr)))
  read_taxstats(filename = list.files(pattern = "\\.((txt)|(csv))$", 
                                      path = directory, 
                                      recursive = TRUE, 
                                      full.names = TRUE)[1])
}


sample_file_0304 <- get_sample_file(2004)
sample_file_0405 <- get_sample_file(2005)
sample_file_0506 <- get_sample_file(2006)
sample_file_0607 <- get_sample_file(2007)
sample_file_0708 <- get_sample_file(2008)
sample_file_0809 <- get_sample_file(2009)
sample_file_0910 <- get_sample_file(2010)
sample_file_1011 <- get_sample_file(2011)
sample_file_1112 <- get_sample_file(2012)
sample_file_1213 <- get_sample_file(2013)