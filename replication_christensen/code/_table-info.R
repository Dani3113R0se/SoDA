CountFE <- function(m, term) {
  x <- m$fe[term][[1]] %>% unique() %>% length() %>% format(big.mark = ",")
  x[x == "0"] <- ""
  x
}

TableInfo <- function(model_list,
  cell = TRUE, year = TRUE, country_year = TRUE,
  area_year = TRUE, cell_period = TRUE) {
  
  l <- list()
  
  if(cell){
    l[[length(l) + 1]] <- c("\\hline \\\\[-1.8ex] Cell FEs", 
      sapply(model_list, CountFE, term = "cell_number_5x5"))
  }
  if(cell_period){
    l[[length(l) + 1]] <- cell_period_fe <- c("Cell-Period FEs",
      sapply(model_list, CountFE, term = "cell_period"))
  }
  if(year){
    l[[length(l) + 1]] <- year_fe <- c("Year FEs", 
      sapply(model_list, CountFE, term = "year"))
  }
  if(country_year){
    l[[length(l) + 1]] <- country_year_fe <- c("Country-Year FEs", 
      sapply(model_list, CountFE, term = "country_year"))
  }
  if(area_year){
    l[[length(l) + 1]] <- area_year_fe <- c("Area-Year FEs", 
      sapply(model_list, CountFE, term = "area_year"))
  }
  
  l[[length(l) + 1]] <- c("Mean($y_{it}$)", 
    sapply(model_list, function(x) 
      format(round(mean(x$response), 4), scientific = FALSE)))
  
  l
}

tbl_note <- c("Robust standard errors clustered on cell; $^{\\dagger} p <$ 0.1, $^*p <$ 0.05")