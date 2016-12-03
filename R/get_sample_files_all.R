#' Get the object containing all sample files
#' 
#' @param assign.env The environment in which to assign \code{sample_files_all}.
#' @return A promise to \code{sample_files_all}. See \code{?sample_files}.
#' @import data.table
#' @export

get_sample_files_all <- function(assign.env = parent.frame(2)){
  if (!"package:data.table" %in% search()){
    stop("Attach the data.table package.")
  } else {
    delayedAssign("sample_files_all", 
                  {
                    adt <- function(...) data.table::as.data.table(...)
                    fy.year <- NULL
                    WEIGHT <- NULL
                    
                    sample_files_all <- data.table::rbindlist(list("2003-04"  = sample_file_0304,  # <-get_sample_file(2004)
                                                                   "2004-05"  = sample_file_0405,  # <-get_sample_file(2005)
                                                                   "2005-06"  = sample_file_0506,  # <-get_sample_file(2006)
                                                                   "2006-07"  = sample_file_0607,  # <-get_sample_file(2007)
                                                                   "2007-08"  = sample_file_0708,  # <-get_sample_file(2008)
                                                                   "2008-09"  = sample_file_0809,  # <-get_sample_file(2009)
                                                                   "2009-10"  = sample_file_0910,  # <-get_sample_file(2010)
                                                                   "2010-11"  = sample_file_1011,  # <-get_sample_file(2011)
                                                                   "2011-12"  = sample_file_1112,  # <-get_sample_file(2012)
                                                                   "2012-13"  = sample_file_1213,  # <-get_sample_file(2013))
                                                                   "2013-14"  = sample_file_1314
                    ), use.names = TRUE, fill = TRUE, idcol = "fy.year")
                    sample_files_all[, WEIGHT := dplyr::if_else(fy.year > "2010-11", 50L, 100L)]
                    sample_files_all
                  }, 
                  assign.env = assign.env)
  }
}
