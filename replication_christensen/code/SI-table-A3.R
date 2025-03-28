# table A.3

rm(list = ls()); gc()

pnl_dt <- readRDS("data/did-ucdp.rds")
brdr_dt <- readRDS("data/did-ucdp-border.rds")

#================================================================
# Functions to estimate models and extract relevant information for regression table:

DiD <- function(dv = "ind_event", iv = "ind_mine",
  unit_fe = "cell_number_5x5", time_fe = "year",  
  cl_var = "cell_number_5x5", dt = pnl_dt) {
  
  form <- paste(dv, "~", iv, "|", unit_fe, "+", time_fe, 
    "| 0 |", cl_var) %>%
    as.formula()
  
  felm(form, data = dt, keepCX = FALSE)
}

Models <- function(y = "ind_event") {
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

source("code/_table-info.R")

#================================================================
# UCDP Event:

m_list <- Models(y = "ind_event")

tbl_info <- TableInfo(m_list)

col_names <- c("Full", "Full", "Full",
  "Border", "Border$\\leq$2",
  "Full", "Border$\\leq$2")

t1 <- stargazer(m_list,
  covariate.labels = c("$D_{it}$", "$P_{it}$ (Placebo)"),
  dep.var.labels = c("$\\mathbb{1}$(UCDP Event)", ""),
  column.labels = col_names,
  keep.stat = "n",
  add.lines = list(tbl_info[[length(tbl_info)]]),
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 2,
  title = "Mining Activity and Pr(Armed Conflict)",
  label = "tab:did_ucdp")

t_top <- t1[grep("ht!", t1):(grep("^Observations", t1) - 1)]

rm(m_list); gc()

#================================================================
# UCDP Event with more than 25 fatalities:

m_list <- Models(y = "I(sum_over25 > 0)")

tbl_info <- TableInfo(m_list)

t2 <- stargazer(m_list,
  covariate.labels = c("$D_{it}$", "$P_{it}$ (Placebo)"),
  dep.var.labels = c("$\\mathbb{1}$(UCDP Event $>$ 25 Deaths)", ""),
  keep.stat = "n",
  add.lines = tbl_info,
  star.cutoffs = c(.1, .05), star.char = c("\\dagger", "*"),
  notes = tbl_note,
  notes.append = FALSE,
  table.placement = "ht!", column.sep.width = "0pt",
  digits = 2)

t_bottom <- t2[c(grep("Dependent variable", t2):(grep("Dependent variable", t2) + 2),
  grep("^ \\$D", t2):length(t2))]

fileConn <- file("tables/SI-table-A3.tex")
writeLines(c(t_top, "\\\\[-1.8ex]\\hline \\hline \\\\[-1.8ex]", t_bottom), fileConn)
close(fileConn)