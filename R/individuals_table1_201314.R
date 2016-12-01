#' Table 1 from 2013-14 taxstats
#' @description This is a molten form of the data source with some oddities (such as encoding) removed.
#' @source \url{http://data.gov.au/dataset/taxation-statistics-2013-14/resource/3cd6dee1-785f-4876-a282-ebcf00f9949a}
#' 
#' @format A data frame describing 258,774 taxpayers with 67 variables:
#' \describe{
#' \item{Superheading}{Grouping of \code{Selected_items}.}
#' \item{Selected_items}{The variable for the \code{fy_year}.}
#' \item{fy_year}{The financial year to which the Count and Sum apply.}
#' \item{Count}{The number of nonzero observations. \code{NA} means the observation was not recorded for that financial year.}
#' \item{Sum}{The sum of the \code{Selected_item} for that \code{fy_year}.}
#' }
#' 
"individuals_table1_201314"
