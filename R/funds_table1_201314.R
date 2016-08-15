#' Super funds time series data
#' 
#' @source \url{https://data.gov.au/dataset/taxation-statistics-2013-14/resource/15981dd2-ed4a-44e4-8def-0ccfc0ef8090?inner_span=True}
#' 
#' @description This is a long form of the data relating to super funds on data.gov.au.
#' 
#' @format A data table with 2652 rows and 5 columns.
#' \describe{
#' \item{Superheading}{The group of the \code{Selected_items}. (Mostly equates to the boldface cells of the original Excel file.)}
#' \item{Selected_items}{The variable, often called Selected items in the sheet.}
#' \item{fy_year}{The financial year.}
#' \item{Count}{The number (of individuals etc) with nonzero values. (Corresponds to no. in original.)}
#' \item{Sum}{The total value (in dollars). (Corresponds to $ in original.)}
#' }
#' 
"funds_table1_201314"