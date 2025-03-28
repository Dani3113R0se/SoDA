# table A.6

rm(list = ls()); gc()

pnl_dt <- readRDS("data/did-acled.rds")

#================================================================
# Functions to estimate models and extract relevant information for regression table:

DiD <- function(dv = "ind_protest", iv = "ind_mine",
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

m_list[[1]] <- DiD(dt = pnl_dt, iv = "ind_mine + china")
m_list[[length(m_list) + 1]] <- DiD(dt = pnl_dt, iv = "ind_mine + china", 
  time_fe = "country_year")

m_list[[length(m_list) + 1]] <- DiD(dt = pnl_dt, iv = "ind_mine + tax_haven")
m_list[[length(m_list) + 1]] <- DiD(dt = pnl_dt, iv = "ind_mine + tax_haven", 
  time_fe = "country_year")

m_list[[length(m_list) + 1]] <- DiD(dt = pnl_dt, iv = "ind_mine + government")
m_list[[length(m_list) + 1]] <- DiD(dt = pnl_dt, iv = "ind_mine + government", 
  time_fe = "country_year")

covars <- c("$D_{it}$", 
  "$D_{it}\\times\\mathbb{1}$(China)",
  "$D_{it}\\times\\mathbb{1}$(Government)",
  "$D_{it}\\times\\mathbb{1}$(Tax Haven)")

tbl_info <- TableInfo(m_list, area_year = FALSE, cell_period = FALSE)

stargazer(m_list,
  covariate.labels = covars,
  dep.var.labels = c("", "$\\mathbb{1}$(Protest)", ""),
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 3,
  title = "Mining Activity, Pr(Protest), and Owners' Origins",
  label = "tab:did_acled_taxhaven",
  out = "tables/SI-table-A6.tex")
