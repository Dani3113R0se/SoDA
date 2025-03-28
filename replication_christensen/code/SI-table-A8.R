# table A.8

rm(list = ls()); gc()

pnl_dt <- readRDS("data/did-price-env-acled.rds")

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


vars <- c("surface", "min_dist_wdpa", "mean_water_stress", "env_risk_exp")

l <- list()
for(v in seq_along(vars)) {
  l[[length(l) + 1]] <- DiD(iv = paste("log_val * ", vars[v]),
    time_fe = "country_year",
    dt = pnl_dt[sum_mines > 0]) 
}

stargazer(l, keep.stat = "n", type = "text",
  omit = "^min_dist_wdpa|^mean_water_stress|^surface|^env_")

tbl_info <- TableInfo(l, area_year = FALSE, cell_period = FALSE, year = FALSE)

covars <- c(paste0("log(Price$_{it}$)", 
  c("", 
    "$\\times\\mathbb{1}$(Surface Mine)$_i$", 
    "$\\times$Min(Dist. Protected Area)$_i$",
    "$\\times$Avg. Water Stress$_i$")),
  "Env. Risk Exposure$_{ct}$",
  "$D_{it}\\times$Env. Risk Exposure$_{ct}$")

stargazer(l,
  font.size = "footnotesize",
  omit = "^min_dist_wdpa|^mean_water|^surface|^env_",
  covariate.labels = covars,
  dep.var.labels = "",
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 2,
  title = "World Mineral Prices, Environmental Hazards, and Pr(Protest or Riot)",
  label = "tab:did_acled_price_environment",
  out = "SI-table-A8.tex")

# Note: due to a stargazer bug, the output needs to be copied and pasted into a tex file. Also the dependent variable label needs to be manually adjusted.