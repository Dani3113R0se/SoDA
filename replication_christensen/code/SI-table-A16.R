# table A.16

rm(list = ls()); gc()
dt_list <- readRDS("data/other-datasets-price.rds")

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
l[[1]] <- DiD(dt = dt_list$acled)
l[[2]] <- DiD(dt = dt_list$acled, time_fe = "country_year")

l[[3]] <- DiD(dt = dt_list$icews)
l[[4]] <- DiD(dt = dt_list$icews, time_fe = "country_year")

l[[5]] <- DiD(dt = dt_list$gdelt)
l[[6]] <- DiD(dt = dt_list$gdelt, time_fe = "country_year")

l[[7]] <- DiD(dt = dt_list$scad, dv = "ind_protest")
l[[8]] <- DiD(dt = dt_list$scad, dv = "ind_protest", time_fe = "country_year")
# This is the same outcome as ind_event in SI-tabel-A15.R; it was just labeled differently. 

tbl_info <- TableInfo(l, area_year = FALSE, cell_period = FALSE)

col_names <- c(
  rep("ACLED", 2),
  rep("ICEWS", 2),
  rep("GDELT", 2),
  rep("SCAD", 2)
)

tbl_info[[length(tbl_info) + 1]] <- c("Var($D_{it}$) = 0", rep("$\\checkmark$", 8))

stargazer(l,
  covariate.labels = c("log(Price)$_{it}$"),
  column.labels = col_names,
  dep.var.labels = rep("$\\mathbb{1}$(Protest)", 2),
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 3,
  title = "Effect of World Mineral Prices on the Pr(Protest)",
  label = "tab:did_price_other",
  out = "tables/SI-table-A16.tex")
