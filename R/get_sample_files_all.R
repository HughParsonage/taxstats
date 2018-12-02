#' Get the object containing all sample files
#' 
#' @return All sample files bound by row \code{sample_files_all}. See \code{?sample_files}.
#' 
#' \code{get_sample_files_all2()} is different in two ways: (1) uses a \code{fy_year} name,
#' instead of \code{fy.year}, and (2) uses the same names as in \code{sample_file_1314}.
#' 
#' @import data.table
#' @export get_sample_files_all get_sample_files_all2

get_sample_files_all <- function(){
  if (!requireNamespace("data.table", quietly = TRUE)){
    stop("Attach the data.table package.")
  } else {
    fy.year <- NULL
    WEIGHT <- NULL
    
    sample_files_all <-
      rbindlist(lapply(list("2003-04"  = sample_file_0304,  # <-get_sample_file(2004)
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
                       as.data.table),
                use.names = TRUE, 
                fill = TRUE,
                idcol = "fy.year")
    wt_50 <- .subset2(sample_files_all, "fy.year") > "2010-11"
    sample_files_all$WEIGHT <- ifelse(wt_50, 50L, 100L)
    
    sample_files_all
  }
}

get_sample_files_all2 <- function() {
  standardize <- function(yr) {
    suffix <- paste0(substr(yr - 1L, 3, 4),
                     substr(yr, 3, 4))
    object_name <- paste0("sample_file_", suffix)
    DT <- getExportedValue("taxstats", object_name)
    out <- as.data.table(DT)
    out[, "fy_year" := grattan::yr2fy(yr)]
    do_setnames <- function(dt, old, new) {
      if (old %in% names(dt)) {
        setnames(dt, old, new)
      }
      dt
    }
    do_setnames(out, "Birth_year", "age_range")
    do_setnames(out, "Marital_status", "Partner_status")
    do_setnames(out, "HECS_accum_ind", "Help_debt")
    out
  }
  
  rbindlist(lapply(2004:2014, standardize),
            use.names = TRUE,
            fill = TRUE)
}


