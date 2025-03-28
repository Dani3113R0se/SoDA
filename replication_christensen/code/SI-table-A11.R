# table A.11

rm(list = ls()); gc()

ind_10_dt <- readRDS("data/dhs-wealth-10km.rds")
ind_20_dt <- readRDS("data/dhs-wealth-20km.rds")

#================================================================
# Using different extract function:
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
m_list[[1]] <- felm(asset_ind ~ moved | pid + year | 0 | pid,
  data = ind_10_dt[ind_mine ==1])
m_list[[2]] <- felm(asset_ind ~ moved_after | pid + year | 0 | pid,
  data = ind_10_dt[ind_mine ==1])

m_list[[3]] <- felm(asset_ind ~ moved | pid + year | 0 | pid,
  data = ind_20_dt[ind_mine ==1])
m_list[[4]] <- felm(asset_ind ~ moved_after | pid + year | 0 | pid,
  data = ind_20_dt[ind_mine ==1])

tbl_info <- TableInfo(m_list, country_year = FALSE)
tbl_info[[length(tbl_info) + 1]] <- c("\\hline \\\\[-1.8ex] Mining Years Only", 
  rep("$\\checkmark$", 4))

col_names <- c(rep("10km", 2), rep("20km", 2))

stargazer(m_list,
  dep.var.labels = "HH Asset Index",
  covariate.labels = c("$\\mathbb{1}$(Moved)", "$\\mathbb{1}$(Moved Post-Mining)"),
  column.labels = col_names,
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 2,
  title = "Wealth Differences between Permanent Residents and Migrants",
  label = "tab:did_dhs_migration_wealth",
  out = "tables/SI-table-A11.tex")