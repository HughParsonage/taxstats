#' @title Superannuation variables
#' 
#' @description A way to add superannuation variables to sample files. 
#' 
#' @param .sample.file A sample file onto which new columns are to be added.
#' @return A data.table 
#' @import data.table
#' @export

mutate_super_vars <- function(.sample.file){
  stopifnot(data.table::is.data.table(.sample.file))
  
  if (!all(c("MCS_Emplr_Contr", 
             "MCS_Prsnl_Contr", 
             "MCS_Othr_Contr", 
             "MCS_Ttl_Acnt_Bal") %in% names(.sample.file))){
    stop("The sample file you requested does not have the variables needed for this function.")
  }
  
  # Pre-tax contributions
  .sample.file[ , "pre_tax_contributions" := rowSums(.SD), .SDcols = c("MCS_Emplr_Contr", "Non_emp_spr_amt")]
}