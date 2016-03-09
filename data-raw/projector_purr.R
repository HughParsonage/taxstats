library(forecast)
library(data.table)
library(dplyr)
library(ggplot2)
library(magrittr)
library(purrr)

sample_files_all %>% 
  select_(.dots = c("fy.year", names(.)[sapply(., is.numeric)])) %>% 
  group_by(fy.year) %>% 
  summarise_each(funs(mean)) %>% 
  select(Alow_ben_amt) %>% 
  {
    ggplot(., aes(x = 1:nrow(.), y = Alow_ben_amt)) + 
      geom_line()
  }

all_num_vars_avgs_by_fyyear <-
  sample_files_all %>% 
  select_(.dots = c("fy.year", names(.)[sapply(., is.numeric)])) %>% 
  group_by(fy.year) %>% 
  summarise_each(funs(mean)) 

alow_ben_amt.arima <- auto.arima(ts(all_num_vars_avgs_by_fyyear$Alow_ben_amt))
plot(forecast(alow_ben_amt.arima))

## For each variable we want an arima model 
## and to use that to forecast ahead.
forecasts_by_var <- 
  sample_files_all %>%
  select_(.dots = c("fy.year", names(.)[sapply(., is.numeric)])) %>%
  select(-c(WEIGHT, Ind)) %>%
  group_by(fy.year) %>% 
  summarise_each(funs(mean)) %>%
  melt.data.table(id.vars = c("fy.year")) %>% 
  base::split(.$variable) %>%
  purrr::map(~forecast::forecast(forecast::auto.arima(ts(.$value))))

generic_inflator <- function(.sample_file, h){
  stopifnot(is.integer(h), h >= 0)
  if (h == 0){
    return(.sample_file)
  }
  
  forecast_ahead_h <- function(object, hh = h, ...){
    forecast::forecast(object, h = hh, ...)
  }
  
  extract_mean <- function(.prev){
    as.numeric(magrittr::use_series(magrittr::extract(.prev, "mean"), "mean"))
  }
  
  select_which_ <- function(.data, which, .and.dots){
    which <- match.fun(which)
    if (!missing(.and.dots)){
      dplyr::select_(.data, .dots = c(names(.data)[sapply(.data, which)] , .and.dots))
    } else {
      dplyr::select_(.data, .dots = names(.data)[sapply(.data, which)])
    }
  }
  
  
  
  forecasts_by_var <- 
    sample_files_all %>%
    select_which_(is.numeric, "fy.year") %>%
    dplyr::select(-c(WEIGHT, Ind)) %>%
    dplyr::select(-c(Taxable_Income, Tot_inc_amt, Tot_ded_amt)) %>%
    dplyr::group_by(fy.year) %>% 
    dplyr::summarise_each(funs(mean)) %>%
    data.table::melt.data.table(id.vars = c("fy.year")) %>% 
    base::split(.$variable) %>%
    purrr::map(~forecast::auto.arima(ts(.$value))) %>%
    purrr::map(forecast_by) %>%
    purrr::map(extract_mean) %>% 
    data.table::as.data.table(.) %>%
    .[h]
  
  # Forecast only on the nonzero mean
  mean_of_nonzero <- function(x){
    mean(x[x > 0])
  }
  
  is.nonnegative <- function(vec){
    is.numeric(vec) && !any(is.na(vec)) && all(vec >= 0)
  }
  
  forecasts_by_var_excl_0 <- 
    sample_files_all %>%
    dplyr::select(-c(WEIGHT, Ind)) %>%
    dplyr::select(-c(Taxable_Income, Tot_inc_amt, Tot_ded_amt)) %>%
    select_which_(is.nonnegative, "fy.year") %>%
    dplyr::group_by(fy.year) %>% 
    dplyr::summarise_each(funs(mean_of_nonzero)) %>%
    data.table::melt.data.table(id.vars = c("fy.year")) %>% 
    base::split(.$variable) %>%
    purrr::map(~forecast::auto.arima(ts(.$value))) %>%
    purrr::map(forecast_by) %>%
    purrr::map(extract_mean) %>% 
    data.table::as.data.table(.) %>%
    .[h]
}

sample_file_1213 %>%
  mutate_each()

forecasts_by_var_ets <- 
  sample_files_all %>%
  select_(.dots = c("fy.year", names(.)[sapply(., is.numeric)])) %>%
  select(-c(WEIGHT, Ind)) %>%
  group_by(fy.year) %>% 
  summarise_each(funs(mean)) %>%
  melt.data.table(id.vars = c("fy.year")) %>% 
  base::split(.$variable) %>%
  purrr::map(~forecast::forecast((ts(.$value))))

## forecast::auto.arima gives greater inflation of wages than wage_inflator, 


