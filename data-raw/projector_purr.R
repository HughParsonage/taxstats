

## For each variable we want an arima model 
## and to use that to forecast ahead.
generic_inflator <- function(.sample_file, vars, h, fy.year.of.sample.file = "2012-13", nonzero = FALSE){
  stopifnot(is.integer(h), h >= 0)
  if (h == 0){
    return(.sample_file)
  }
  
  forecast_ahead_h <- function(object, hh = h, ...){
    forecast::forecast(object, h = hh, ...)
  }
  
  extract_mean <- function(.prev){
    as.numeric(magrittr::use_series(magrittr::extract(.prev, 
                                                      "mean"), 
                                    "mean"))
  }
  
  select_which_ <- function(.data, Which, .and.dots){
    which <- match.fun(Which)
    if (!missing(.and.dots)){
      dplyr::select_(.data, .dots = c(names(.data)[sapply(.data, which)] , .and.dots))
    } else {
      dplyr::select_(.data, .dots = names(.data)[sapply(.data, which)])
    }
  }
  
  last_over_first <- function(x){
    dplyr::last(x) / dplyr::first(x)
  }
  
  if (!nonzero){
    mean_of_each_var <- 
      sample_files_all %>%
      dplyr::select_(.dots = c("fy.year", vars)) %>%
      select_which_(is.numeric, "fy.year") %>%
      dplyr::group_by(fy.year) %>%  
      dplyr::summarise_each(dplyr::funs(mean)) 
  } else {
    # Forecast only on the nonzero mean
    mean_of_nonzero <- function(x){
      mean(x[x > 0])
    }
    
    is.nonnegative <- function(vec){
      is.numeric(vec) && !any(is.na(vec)) && all(vec >= 0)
    }
    
    mean_of_each_var <- 
      sample_files_all %>%
      dplyr::select_(.dots = c("fy.year", vars)) %>%
      select_which_(is.numeric, "fy.year") %>%
      dplyr::group_by(fy.year) %>%  
      dplyr::summarise_each(dplyr::funs(mean_of_nonzero))
  }
  
  forecaster <- function(x){
    # Consider using hybridf
    
    # Condition for ets / auto.arima
    if (!any(is.na(x))){
      forecast::ets(x)
    } else {
      forecast::auto.arima(ts(x))
    }
  }
    
  
  point_forecasts_by_var <- 
    mean_of_each_var %>%
    data.table::melt.data.table(id.vars = c("fy.year")) %>% 
    base::split(.$variable) %>%
    purrr::map(~forecaster(.$value)) %>%
    purrr::map(forecast_ahead_h) %>%
    purrr::map(extract_mean) %>% 
    data.table::as.data.table(.) 
  
  
  data.table::rbindlist(list(mean_of_each_var, 
                             point_forecasts_by_var), 
                        use.names = TRUE, 
                        fill = TRUE) %>%
    dplyr::mutate(fy_year = grattan::yr2fy(1:n() - 1 + grattan::fy2yr(dplyr::first(fy.year)))) %>% 
    dplyr::filter(fy_year %in% c(fy.year.of.sample.file, last(fy_year))) %>% 
    dplyr::summarise_each(funs(last_over_first), -c(fy_year, fy.year)) %>%
    data.table::melt.data.table(measure.vars = names(.), value.name = "inflator")
  
  ## We use inflators that we know to be useful. (Sw_amt is a wage inflator)
  ## Otherwise we use 
  ## For those columns with nonnegative values, we use the inflator by var mean 0
  ## For the remainder, infaltor by var.
  
  ## The inflators look too large.

}


