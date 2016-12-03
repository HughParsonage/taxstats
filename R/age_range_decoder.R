#' @title Decode age ranges in taxstats
#' 
#' @description Makes the idiosyncratic \code{age_range} in the sample files suitable for analysis. Join the sample file with this table 
#' (after \code{data.table::setkeyv(sample_file_1314, "age_range")}).
#' @format A table of 12 rows and 2 columns:
#' \describe{
#' \item{age_range}{An integer from 0 to 11 representing birth year ranges.}
#' \item{age_range_description}{An (correctly) ordered factor containing human-readable versions.}
#' }
#' 
#' @examples merge(sample_file_1314, age_range_decoder, by = "age_range")
#' 
"age_range_decoder"