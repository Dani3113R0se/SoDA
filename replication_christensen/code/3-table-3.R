# table 3

rm(list = ls()); gc()

pnl_dt <- readRDS("data/did-price-acled-eiti.rds")

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

l <- list()

l[[1]] <- DiD(dt = pnl_dt[sum_mines > 0], cl_var = "country")

l[[length(l) + 1]] <-DiD(dt = pnl_dt[sum_mines > 0],
  iv = "log_val * candidate_l1", cl_var = "country")

l[[length(l) + 1]] <-DiD(dt = pnl_dt[sum_mines > 0],
  iv = "log_val * candidate_l1 + factor(country) * year", cl_var = "country")

l[[length(l) + 1]] <-DiD(dt = pnl_dt[sum_mines > 0],
  iv = "log_val * candidate_l1 + log_val * corruption_l1", cl_var = "country")

l[[length(l) + 1]] <-DiD(dt = pnl_dt[sum_mines > 0],
  iv = "log_val * compliant_l1", cl_var = "country")

l[[length(l) + 1]] <-DiD(dt = pnl_dt[sum_mines > 0],
  iv = "log_val * compliant_l1  + factor(country) * year", cl_var = "country")

l[[length(l) + 1]] <-DiD(dt = pnl_dt[sum_mines > 0],
  iv = "log_val * compliant_l1 + log_val * corruption_l1", cl_var = "country")

#================================================================

tbl_info <- TableInfo(l, country_year = FALSE, cell_period = FALSE, area_year = FALSE)

tbl_info[[length(tbl_info) + 1]] <- c("\\hline \\\\[-1.8ex] Mining Cell-Years Only", 
  rep("$\\checkmark$", 7))
tbl_info[[length(tbl_info) + 1]] <- c("Country-specific Trends", 
  rep("", 2), "$\\checkmark$", rep("", 2), "$\\checkmark$", "")

covars <- c("log(Price)$_{it}$", 
  "$\\mathbb{1}$(Candidate)$_{c, t - 1}$", 
  "Corruption$_{c, t - 1}$",
  "log(Price)$_{it} \\times \\mathbb{1}$(Candidate)$_{c,t - 1}$",
  "log(Price)$_{it} \\times$ Corruption$_{c, t - 1}$",
  "$\\mathbb{1}$(Compliant)$_{ct}$", 
  "log(Price)$_{it} \\times \\mathbb{1}$(Compliant)$_{c, t - 1}$",
  "log(Price)$_{it} \\times$ Corruption$_{c, t - 1}$")

stargazer(l,
  covariate.labels = covars,
  dep.var.labels = c(rep("", 3), "$\\mathbb{1}$(Protest or Riot)", rep("", 3)),
  omit = "factor(country)*|year",
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = c("Robust SEs clustered on country; $^{\\dagger} p <$ 0.1, $^*p <$ 0.05"),
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 3,
  title = "Mineral Prices, EITI, and Pr(Protest)",
  label = "tab:did_price_acled_eiti",
  out = "tables/table-3.tex")