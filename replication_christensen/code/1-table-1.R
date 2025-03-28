# table 1

rm(list = ls()); gc()

pnl_dt <- readRDS("data/did-acled.rds")
brdr_dt <- readRDS("data/did-acled-border.rds")

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

Models <- function(y = "ind_protest") {
  m_list <- list()
  
  m_list[[1]] <- DiD(dv = y)
  m_list[[2]] <- DiD(dv = y, time_fe = "country_year")
  m_list[[3]] <- DiD(dv = y, unit_fe = "cell_period")
  m_list[[4]] <- DiD(dv = y, time_fe = "area_year", dt = brdr_dt)
  m_list[[5]] <- DiD(dv = y, time_fe = "area_year", dt = brdr_dt[border < 3])
  m_list[[6]] <- DiD(dv = y, iv = "placebo", time_fe = "country_year")
  m_list[[7]] <- DiD(dv = y, iv = "placebo", time_fe = "area_year", 
    dt = brdr_dt[border < 3])
  
  m_list
}

# Loading functions for extracting table information:
source("code/_table-info.R")

#================================================================

m_list <- Models()
# stargazer(m_list, keep.stat = "n", type = "text")
tbl_info <- TableInfo(m_list)

stargazer(m_list,
  covariate.labels = c("$D_{it}$", "$P_{it}$ (Placebo)"),
  dep.var.labels = c("$\\mathbb{1}$(Protest or Riot)", ""),
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 2,
  title = "Effect of Mining Activity on the Pr(Protest or Riot)",
  label = "tab:did_acled",
  out = "tables/table-1.tex")

