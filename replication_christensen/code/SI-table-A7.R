# table A.7

rm(list = ls()); gc()

pnl_dt <- readRDS("data/did-env-acled.rds")

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

m_list[[1]] <- DiD(iv = "ind_mine * surface")
m_list[[2]] <- DiD(iv = "ind_mine * surface", time_fe = "country_year")
m_list[[3]] <- DiD(iv = "ind_mine * min_dist_wdpa")
m_list[[4]] <- DiD(iv = "ind_mine * min_dist_wdpa", time_fe = "country_year")
m_list[[5]] <- DiD(iv = "ind_mine * mean_water_stress")
m_list[[6]] <- DiD(iv = "ind_mine * mean_water_stress", time_fe = "country_year")
m_list[[7]] <- DiD(iv = "ind_mine * env_risk_exp")
m_list[[8]] <- DiD(iv = "ind_mine * env_risk_exp", time_fe = "country_year")

#================================================================

tbl_info <- TableInfo(m_list, area_year = FALSE, cell_period = FALSE)

stargazer(m_list, type = "text", keep.stat = "n",
  omit = "^min_dist_wdpa|^mean_water_stress|ind_mine:surface", digits = 3,
  add.lines = tbl_info)

covars <- c(paste0("$D_{it}$", 
  c("", 
    "$\\times\\mathbb{1}$(Surface Mine)$_i$", 
    "$\\times$Min(Dist. Protected Area)$_i$",
    "$\\times$Avg. Water Stress$_i$")),
  "Env. Risk Exposure$_{ct}$",
  "$D_{it}\\times$Env. Risk Exposure$_{ct}$")

stargazer(m_list,
  font.size = "footnotesize",
  omit = "^min_dist_wdpa|^mean_water_stress|ind_mine:surface",
  covariate.labels = covars,
  dep.var.labels = rep("$\\mathbb{1}$(Protest or Riot)", 4),
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 2,
  title = "Mining Activity, Environmental Hazards, and Pr(Protest or Riot)",
  label = "tab:did_acled_environment",
  out = "tables/SI-table-A7.tex")

# Note: due to a stargazer bug, the output needs to be copied and pasted into a tex file. Also the dependent variable label needs to be manually adjusted.