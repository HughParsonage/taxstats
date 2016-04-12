#' @title Benchmarks for the sample file
#' 
#' @name benchmarking_201314_orig
#' @note This is the original xlsx file with names changed. 
#' @format A data frame with 70 rows and 10 variables. Variables probably have the following definitions. Consult the ATO for confirmation.
#' \describe{
#' \item{\code{data_item}}{The column name in the 2013-14 sample file}
#' \item{\code{description}}{A short description of that variable}
#' \item{\code{count_actual}}{How many individuals in 2013-14 entered a (nonzero?) value for this variable.}
#' \item{\code{sum_actual}}{The sum across all individuals of the values in this field.}
#' \item{\code{count_available_for_sample}}{How many of \code{count_actual} could be used in the sample file.}
#' \item{\code{sum_available}}{The \code{sum_actual} restricted to \code{count_available_for_sample}.}
#' \item{\code{count_sample}}{The number of nonzero entries for this variable in the sample file.}
#' \item{\code{sum_sample}}{The sum of this variable in the sample file.}
#' \item{\code{count_sample_over_actual}}{Simply \code{count_sample} divided by \code{count_actual}.}
#' \item{\code{sum_sample_over_actual}}{Simply \code{sum_sample} divided by \code{sum_actual}}
#' 
#' }
#' 
#' 
#' @details The variables \code{count_sample_over_actual} and \code{sum_sample_over_actual} may be useful for analyzing the 2013-14 sample file.
#' @source \url{https://data.gov.au/dataset/taxation-statistics-individual-sample-files/resource/6ca75bab-96a6-4852-897c-1c0784d2fec9}

"benchmarking_201314_orig"