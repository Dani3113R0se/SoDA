# table A.12

rm(list = ls()); gc()

pnl10_dt <- readRDS("data/dhs-inequality-10km.rds")
pnl20_dt <- readRDS("data/dhs-inequality-20km.rds")

#================================================================
# Functions to estimate models and extract relevant information for regression table:

DiD <- function(dv = "ineq_it", iv = "ind_mine",
  unit_fe = "pid", time_fe = "year",  
  cl_var = "pid", dt = pnl_dt) {
  
  form <- paste(dv, "~", iv, "|", unit_fe, "+", time_fe, 
    "| 0 |", cl_var) %>%
    as.formula()
  
  felm(form, data = dt, keepCX = FALSE)
}

source("code/_table-info.R")

TableInfo <- function(model_list,
  cell = TRUE, year = TRUE, country_year = TRUE) {
  
  l <- list()
  
  if(cell){
    l[[length(l) + 1]] <- c("\\hline \\\\[-1.8ex] Buffer FEs", 
      sapply(model_list, CountFE, term = "pid"))
  }
  if(year){
    l[[length(l) + 1]] <- year_fe <- c("Year FEs", 
      sapply(model_list, CountFE, term = "year"))
  }
  if(country_year){
    l[[length(l) + 1]] <- country_year_fe <- c("Country-Year FEs", 
      sapply(model_list, CountFE, term = "country_year"))
  }
  
  l[[length(l) + 1]] <- c("Mean($y_{it}$)", 
    sapply(model_list, function(x) 
      format(round(mean(x$response), 2), scientific = FALSE)))
  
  l
}

tbl_note <- c("Robust standard errors clustered on mine; $^{\\dagger} p <$ 0.1, $^*p <$ 0.05")

#================================================================

m_list <- list()
m_list[[1]] <- DiD(dt = pnl10_dt)
m_list[[2]] <- DiD(time_fe = "country_year", dt = pnl10_dt)
m_list[[3]] <- DiD(dt = pnl20_dt) 
m_list[[4]] <- DiD(time_fe = "country_year", dt = pnl20_dt) 
m_list[[5]] <- DiD(dv = "mean_asset", dt = pnl10_dt) 
m_list[[6]] <- DiD(dv = "mean_asset", time_fe = "country_year", dt = pnl10_dt) 
m_list[[7]] <- DiD(dv = "mean_asset", dt = pnl20_dt) 
m_list[[8]] <- DiD(dv = "mean_asset", time_fe = "country_year", dt = pnl20_dt) 

tbl_info <- TableInfo(m_list)
col_names <- rep(c(rep("10km", 2), rep("20km", 2)), 2)

stargazer(m_list,
  covariate.labels = c("$D_{it}$"),
  column.labels = col_names,
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 2,
  title = "Mining Activity, Inequality, and Wealth",
  label = "tab:did_dhs_inequality",
  out = "tables/SI-table-A12.tex")
