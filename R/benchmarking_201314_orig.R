#' Benchmarks of the 2013-14 sample file
#'
#'
#' This data table is the benchmarking provided by the ATO as a companion to the sample files.
#' 
#' @source \url{https://data.gov.au/dataset/taxation-statistics-individual-sample-files} under a Creative Commons Attribution 3.0 Australia Licence. \url{https://creativecommons.org/licenses/by/3.0/au/legalcode}.
#'
#' @name benchmarking_201314_orig
#'
#'
#' @format A data frame of 49 observations and 10 columns.
#' \describe{
#' \item{data_item}{The variable in \code{\link{sample_file_1314}}.}
#' \item{description}{A short description of the variable.}
#' \item{count_actual}{The number of taxpayers with nonzero \code{data_item}.}
#' \item{sum_actual}{The sum of \code{data_item} across all taxpayers.}
#' \item{count_available_for_sample}{The number of taxpayers with nonzero \code{data_item} who were available for sampling.}
#' \item{sum_available_for_selection}{The sum of \code{data_item} across all taxpayer who were available for sampling.}
#' \item{count_sample}{The number of observations in the sample file.}
#' \item{sum_sample}{The sum of \code{data_item} in the sample file.}
#' \item{count_sample_over_actual}{The fraction \eqn{\frac{\mathtt{count_sample}}{\mathtt{count_actual}}}.}
#' \item{sum_sample_over_actual}{The financial/tax year of the original sample file.}
#' }

"benchmarking_201314_orig"