#' Get the object containing all sample files
#' 
#' @return All sample files bound by row \code{sample_files_all}. See \code{?sample_files}.
#' @export

get_sample_files_all <- function(){
  if (!requireNamespace("data.table", quietly = TRUE)){
    stop("Attach the data.table package.")
  } else {
    fy.year <- NULL
    WEIGHT <- NULL
    
    sample_files_all <- data.table::rbindlist(lapply(list("2003-04"  = sample_file_0304,  # <-get_sample_file(2004)
                                                          "2004-05"  = sample_file_0405,  # <-get_sample_file(2005)
                                                          "2005-06"  = sample_file_0506,  # <-get_sample_file(2006)
                                                          "2006-07"  = sample_file_0607,  # <-get_sample_file(2007)
                                                          "2007-08"  = sample_file_0708,  # <-get_sample_file(2008)
                                                          "2008-09"  = sample_file_0809,  # <-get_sample_file(2009)
                                                          "2009-10"  = sample_file_0910,  # <-get_sample_file(2010)
                                                          "2010-11"  = sample_file_1011,  # <-get_sample_file(2011)
                                                          "2011-12"  = sample_file_1112,  # <-get_sample_file(2012)
                                                          "2012-13"  = sample_file_1213,  # <-get_sample_file(2013))
                                                          "2013-14"  = sample_file_1314),
                                                     data.table::setDT),
                                                     use.names = TRUE, 
                                              fill = TRUE,
                                              idcol = "fy.year")
    wt_50 <- .subset2(sample_files_all, "fy.year") > "2010-11"
    if ("package:data.table" %in% search()) {
      sample_files_all[, `:=`(WEIGHT, hutils::if_else(fy.year > "2010-11", 50L, 100L))]
    } else {
      sample_files_all$WEIGHT <- hutils::if_else(wt_50, 50L, 100L)
    }
    
    sample_files_all
  }
}
