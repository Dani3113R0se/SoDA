# table A.9

rm(list = ls()); gc()

pnl10_dt <- readRDS("data/dhs-migration-10km.rds")
pnl20_dt <- readRDS("data/dhs-migration-20km.rds")

#================================================================
# Functions to estimate models and extract relevant information for regression table:

DiD <- function(dv = "prop_moved", iv = "ind_mine",
  unit_fe = "pid", time_fe = "year",  
  cl_var = "pid", dt = pnl10_dt) {
  
  form <- paste(dv, "~", iv, "|", unit_fe, "+", time_fe, 
    "| 0 |", cl_var) %>%
    as.formula()
  
  felm(form, data = dt, keepCX = FALSE)
}

source("code/_table-info.R")

# Using different extract function:
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
m_list[[1]] <- DiD()
m_list[[2]] <- DiD(time_fe = "country_year")

m_list[[3]] <- DiD(iv = "I(log(value_98_avg))")
m_list[[4]] <- DiD(iv = "I(log(value_98_avg))", time_fe = "country_year")

m_list[[5]] <- DiD(dt = pnl20_dt)
m_list[[6]] <- DiD(dt = pnl20_dt, time_fe = "country_year")

m_list[[7]] <- DiD(dt = pnl20_dt, iv = "I(log(value_98_avg))")
m_list[[8]] <- DiD(dt = pnl20_dt, iv = "I(log(value_98_avg))", 
  time_fe = "country_year")

# stargazer(m_list, keep.stat = "n", type = "text")

tbl_info <- TableInfo(m_list)
tbl_info[[length(tbl_info) + 1]] <- c("\\hline \\\\[-1.8ex] Mining Years Only", 
  rep(c("", "", "$\\checkmark$", "$\\checkmark$"), 2))

col_names <- c(rep("10km", 4), rep("20km", 4))

stargazer(m_list,
  covariate.labels = c("$D_{it}$", "log(Price)$_{it}$"),
  column.labels = col_names,
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 2,
  title = "Mining, Prices, and Migration",
  label = "tab:did_dhs_migration",
  out = "tables/SI-table-A9.tex")
