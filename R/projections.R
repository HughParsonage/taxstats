#' A function for simple projections of sample files
#' 
#' @param sample_file A sample file, most likely the 2012-13 sample file. It is intended that to be the most recent.
#' @param h An integer. How many years should the sample file be projected?
#' @param fy.year.of.sample.file The financial year of \code{sample_file}.
#' @return A sample file of the same number of rows as \code{sample_file} with inflated values (including WEIGHT).


project <- function(sample_file, WEIGHT = 50L, h = 0L, fy.year.of.sample.file = "2012-13"){
  
  stopifnot(is.integer(h), h >= 0L, data.table::is.data.table(sample_file))
  sample_file %<>% dplyr::mutate(WEIGHT = WEIGHT)
  if (h == 0){
    return(sample_file)
  } else {
    current.fy <- fy.year.of.sample.file
    to.fy <- grattan::yr2fy(grattan::fy2yr(current.fy) + h)
    wage.inflator <- grattan::wage_inflator(1, from_fy = current.fy, to_fy = to.fy)
    lf.inflator <- grattan::lf_inflator_fy(from_fy = current.fy, to_fy = to.fy)
    cpi.inflator <- grattan::cpi_inflator(1, from_fy = current.fy, to_fy = to.fy)
    
    col.names <- names(sample_file)
    wagey.cols <- c("Sw_amt", "Rptbl_Empr_spr_cont_amt", "Non_emp_spr_amt")
    lfy.cols <- c("WEIGHT")
    cpiy.cols <- c(grep("WRE", col.names, value = TRUE),
                   "Cost_tax_affairs_amt",
                   "Other_Ded_amt")
    
    ## Inflate:
    if (FALSE){  # we may use this option later
      for (j in which(col.names %in% wagey.cols))
        data.table::set(sample_file, j = j, value = wage.inflator * sample_file[[j]])
      
      for (j in which(col.names %in% lfy.cols))
        data.table::set(sample_file, j = j, value = lf.inflator * sample_file[[j]])
      
      for (j in which(col.names %in% cpiy.cols))
        data.table::set(sample_file, j = j, value = cpi.inflator * sample_file[[j]])
    }
    
    sample_file %>%
      dplyr::mutate(
        new_Sw_amt = wage.inflator * Sw_amt,
        new_Taxable_Income = Taxable_Income + (new_Sw_amt - Sw_amt),
        new_Rptbl_Empr_spr_cont_amt = Rptbl_Empr_spr_cont_amt * wage.inflator,
        new_Non_emp_spr_amt = Non_emp_spr_amt * wage.inflator,
        # inflate Spouse taxable income by the same amount by which Taxable Income was inflated
        new_Spouse_adjusted_taxable_inc = Spouse_adjusted_taxable_inc * (mean(new_Taxable_Income) / mean(Taxable_Income)),
        WEIGHT = WEIGHT * lf.inflator
      ) %>%
      dplyr::mutate(
        Sw_amt = new_Sw_amt,
        Rptbl_Empr_spr_cont_amt = new_Rptbl_Empr_spr_cont_amt,
        Non_emp_spr_amt = new_Non_emp_spr_amt,
        Taxable_Income = new_Taxable_Income,
        Spouse_adjusted_taxable_inc = new_Spouse_adjusted_taxable_inc
      ) %>%
      dplyr::select(-starts_with("new"))
  } 
}