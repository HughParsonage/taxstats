#' The sample files 2003-04 to 2013-14
#'
#' The ATO has a series of sample files of individual tax return information
#' available for more advanced users. These files are confidentialised in order
#' to protect the identities of taxpayers. For income years 2003-04 to 2010-11,
#' files containing a 1\% sample of records are available. From the 2011-12 income
#' year, these files contain a 2\% sample of records.
#'
#' This data table contains all these data sets in a single object, with additional columns \code{fy.year} and \code{WEIGHT}.
#' 
#' @source \url{https://github.com/thmcmahon/ozTaxData/blob/master/R/sample_13_14.R}
#' \url{https://data.gov.au/dataset/taxation-statistics-individual-sample-files} under a Creative Commons Attribution 3.0 Australia Licence. \url{https://creativecommons.org/licenses/by/3.0/au/legalcode}.
#'
#' @name sample_files
#'
#' @usage
#'  data(sample_file_1314)
#'
#' @format A data frame.
#' \describe{
#' \item{fy.year}{The financial/tax year of the original sample file.}
#' \item{WEIGHT}{Sample weight. 100 for the years with a 1\% sample file; 50 for the 2\% years.}
#' \item{Ind}{Unique identifier.}
#' \item{Gender}{Gender (sex). Your sex question. 0 = Male. 1 = Female.}
#' \item{age_range}{Age in five year ranges. Based on Date of Birth label, this is their age as on 30 June 2014.}
#' \item{Birth_year}{(See \code{age_range}.)}
#' \item{Occ_code}{Salary/wage occupation code. Income item 1, label X, first digit}
#' \item{Partner_status}{Has reported a spouse date of birth or hasn't. Derived from Spouse details - married or de facto, Spouse date of birth, label K}
#' \item{Marital_status}{(See \code{Partner_status}.)}
#' \item{Region}{Geographic region based on the Australian Bureau of Statistics Statical Area 4 (SA4) definition using a correspondence with residential postcode.. Derived from residential postcode}
#' \item{Lodgment_method}{Lodgment method. Via tax agent,  or self prepared return.}
#' \item{PHI_Ind}{Private Health Insurance indicator. Derived indicator - if an individual completed some private health insurance details at labels B in the top of page 5.}
#' %\item{\strong{INCOME}}{}
#' \item{Sw_amt}{Salary/wage amount. Income item 1, sum of labels C, D, E, F, G}
#' \item{Alow_ben_amt}{Allowances amount. Income item 2, label K}
#' \item{ETP_txbl_amt}{Employment termination payments taxable component. Income item 4, label I}
#' \item{Grs_int_amt}{Gross interest amount. Income item 10, label L}
#' \item{Aust_govt_pnsn_allw_amt}{Government pensions or allowances amount. Income items 5, label A and item 6, label B}
#' \item{Unfranked_Div_amt}{Unfranked dividends. Income item 11, label S}
#' \item{Frk_Div_amt}{Franked dividends (not including the credit). Income item 11, label T}
#' \item{Dividends_franking_cr_amt}{Dividends franking credit. Income item 11, label U}
#' \item{Net_rent_amt}{Net rental income. Income item 21, net rent box}
#' \item{Gross_rent_amt}{Gross rental income. Income item 21, label P}
#' \item{Other_rent_ded_amt}{Other rental deductions. Income item 21, label U}
#' \item{Rent_int_ded_amt}{Rental interest deductions. Income item 21, label Q}
#' \item{Rent_cap_wks_amt}{Capital works deductions. Income item 21, label F}
#' \item{Net_farm_management_amt}{Net farm management deposits and repayments. Income item 17, Label E}
#' \item{Net_PP_BI_amt}{Net income or loss from business - primary production. Income item 15, label B}
#' \item{Net_NPP_BI_amt}{Net income or loss from business non-primary production. Income item 15, label C}
#' \item{Total_PP_BI_amt}{Total primary production business income. Item P8, sum of labels C, E, N, G and I}
#' \item{Total_NPP_BI_amt}{Total non-primary production business income. Item P8, sum of labels D, B, F, O, H and J}
#' \item{Total_PP_BE_amt}{Total primary production business expenses. Item P8, label S}
#' \item{Total_NPP_BE_amt}{Total non-primary production business expenses. Item P8, label T}
#' \item{Net_CG_amt}{Net capital gains. Income item 18, label A}
#' \item{Tot_CY_CG_amt}{Total capital gains. Income item 18, label H}
#' \item{Net_PT_PP_dsn}{Net partnership and trusts primary production distributions. Income item 13, net primary production distribution box below and to the right of label X}
#' \item{Net_PT_NPP_dsn}{Net partnership and trusts non-primary production distributions. Income item 13, net non-primary production distribution box below and to the right of label Y}
#' \item{Taxed_othr_pnsn_amt}{Australian annuity or superannuation income stream - taxed. Income item 7, labels J and Y}
#' \item{Untaxed_othr_pnsn_amt}{Australian annuity or superannuation income stream - untaxed. Income item 7, labels N and Z}
#' \item{Othr_pnsn_amt}{Australian annuity or pension amount}
#'
#' \item{Other_foreign_inc_amt}{Other net foreign source income. Income item 20, label M}
#' \item{Other_inc_amt}{Other income not separately listed. Eg total income less listed income. Total income or loss (from page 3) less all income listed above}
#' \item{Tot_inc_amt}{Total income. Total income or loss (from page 3)}
#' % \item{\strong{DEDUCTIONS}}{}
#' \item{WRE_car_amt}{WRE car expenses. Deduction item D1, label A}
#' \item{WRE_trvl_amt}{WRE travel expenses. Deduction item D2, label B}
#' \item{WRE_uniform_amt}{WRE uniform expenses. Deduction item D3, label C}
#' \item{WRE_self_amt}{WRE self education expenses. Deduction item D4, label D}
#' \item{WRE_other_amt}{WRE Other expenses. Deduction item D5, label E}
#' \item{Div_Ded_amt}{Dividend Deductions. Deduction item D8, label H}
#' \item{Intrst_Ded_amt}{Interest Deductions. Deduction item D7, label I}
#' \item{Int_Div_ded_amt}{Interest and dividend deductions}
#' \item{Gift_amt}{Gifts or donation deductions. Deduction item D9, label J}
#' \item{Non_emp_spr_amt}{Personal superannuation contributions (previously called non-employer superannuation contributions). Deduction item D12, label H}
#' \item{Cost_tax_affairs_amt}{Cost of managing tax affairs. Deduction item D10, label M}
#' \item{Other_Ded_amt}{Other deductions not separately listed. Eg total deductions less listed deductions. Total deductions - second box below D10 label M on page 3 less deductions listed above}
#' \item{Tot_ded_amt}{Total deductions. Total deductions - second box below D10 label M on page 3 less deductions listed above}
#' % \item{\strong{LOSSES}}{}
#' \item{PP_loss_claimed}{Primary production prior year losses claimed this year. Losses item L1, label F}
#' \item{NPP_loss_claimed}{Non-primary production prior year losses claimed this year. Losses item L1, label Z}
#' % \item{\strong{OTHER}}{}
#' \item{Rep_frng_ben_amt}{Reportable fringe benefits. Income test item IT1, label W}
#' \item{Med_Exp_TO_amt}{Medical expenses tax offset. Tax offset item T6}
#' \item{Asbl_forgn_source_incm_amt}{Assessable foreign source income. Income item 20 Label E}
#' \item{Spouse_adjusted_taxable_inc}{Spouse adjusted taxable income. Calculated from Page 7 Spouse details section}
#' \item{Net_fincl_invstmt_lss_amt}{Net financial investment loss. Income test item IT5, label X}
#' \item{Rptbl_Empr_spr_cont_amt}{Reportable employer superannuation contributions. Income test item IT2, label T}
#' \item{Cr_PAYG_ITI_amt}{Credit for PAYGI installments. Tax credit for pay-as-you-go  installments}
#' \item{TFN_amts_wheld_gr_intst_amt}{Tax file number amounts withheld from gross interest. Income item 10, label M}
#' \item{TFN_amts_wheld_divs_amt}{Tax file number amounts withheld from dividends. Income item 11, Label V}
#' \item{Hrs_to_prepare_BPI_cnt}{Hours taken to prepare and complete the Business and professional items section. End of Business and professional items section section, label S}
#' \item{Taxable_Income}{Taxable income (total income less total deductions and allowable prior year losses). Taxable income or loss, label $ (below label Z on page 3)}
#' \item{Help_debt}{Higher Education Loan Program HELP) debt. HELP debt as at 30 June 2014.}
#' \item{HECS_accum_ind}{Whether or not the individual had a HELP debt before lodgement.}
#' \item{MCS_Emplr_Contr}{Employer contributions from member contribution statements (MCSs). Label 43 from Section E of MCSs, summed up to the individual}
#' \item{MCS_Prsnl_Contr}{Personal contributed amount from MCSs. Label 46 from Section E of MCSs, summed up to the individual}
#' \item{MCS_Othr_Contr}{Other contributions from MCSs. Label 55 less the sum of labels 43 and 46 from Section E of MCSs, summed up to the individual}
#' \item{MCS_Ttl_Acnt_Bal}{Total superannuation accounts balance from MCSs. Label 56 from Section F of MCSs, summed up to the individual}
#' }
NULL


#' @rdname sample_files
"sample_file_1213"

#' @rdname sample_files
"sample_file_1112"

#' @rdname sample_files
"sample_file_1011"

#' @rdname sample_files
"sample_file_0910"

#' @rdname sample_files
"sample_file_0809"

#' @rdname sample_files
"sample_file_0708"

#' @rdname sample_files
"sample_file_0607"

#' @rdname sample_files
"sample_file_0506"

#' @rdname sample_files
"sample_file_0405"

#' @rdname sample_files
"sample_file_0304"

