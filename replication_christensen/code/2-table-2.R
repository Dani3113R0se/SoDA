# table 2

rm(list = ls()); gc()

reg_dt <- readRDS("data/did-price-acled.rds")

#================================================================
# Functions to estimate models and extract relevant information for regression table:

DiD <- function(dv = "ind_protest", iv = "log_val",
  unit_fe = "cell_number_5x5", time_fe = "year",  
  cl_var = "cell_number_5x5", dt = pnl_dt) {
  
  form <- paste(dv, "~", iv, "|", unit_fe, "+", time_fe, 
    "| 0 |", cl_var) %>%
    as.formula()
  
  felm(form, data = dt, keepCX = FALSE)
}

source("code/_table-info.R")

#================================================================

m_list <- list()
# Only using mining cell-years:
m_list[[1]] <- DiD(dt = reg_dt[sum_mines > 0])
m_list[[2]] <- DiD(time_fe = "country_year", dt = reg_dt[sum_mines > 0])
m_list[[3]] <- DiD(dt = reg_dt[sum_mines > 0][no_var_mines == 1])
m_list[[4]] <- DiD(time_fe = "country_year", 
  dt = reg_dt[sum_mines > 0][no_var_mines == 1])
# stargazer(m_list, keep.stat = "n", type = "text")

# Imputing prices of 0 to non-mining cell-years:
m_list[[5]] <- DiD(dt = reg_dt[no_var_mines == 1])
m_list[[6]] <- DiD(time_fe = "country_year", dt = reg_dt[no_var_mines == 1])

#================================================================

tbl_info <- TableInfo(m_list, area_year = FALSE, cell_period = FALSE)

tbl_info[[length(tbl_info) + 1]] <- c("\\hline \\\\[-1.8ex] Mining Cell-Years Only", 
  rep("$\\checkmark$", 4), rep("", 2))
tbl_info[[length(tbl_info) + 1]] <- c("Var(\\# Mines) = 0", 
  rep("", 2), rep("$\\checkmark$", 4))

stargazer(m_list,
  covariate.labels = c("log(Price)$_{it}$"),
  dep.var.labels = rep("$\\mathbb{1}$(Protest or Riot)", 2),
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 3,
  title = "Effect of World Mineral Prices on the Pr(Protest or Riot)",
  label = "tab:did_price_acled",
  out = "tables/table-2.tex")
