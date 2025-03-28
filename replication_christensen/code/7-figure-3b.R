# figure 3b

rm(list = ls()); gc()

brdr_dt <- readRDS("data/did-acled-border.rds")

brdr_dt[, max_year := NA_integer_]
brdr_dt[never_mine == 0, max_year := max(year[ind_mine == 1]), 
  by = cell_number_5x5]

# Treatment indicators for border cells:
brdr_dt[, start_year := max(min_year, na.rm = TRUE), by = mine_cell]
brdr_dt[, end_year := max(max_year, na.rm = TRUE), by = mine_cell]
brdr_dt[, ind_treat := as.integer(year >= start_year & year <= end_year)]

#================================================================

SumCoef <- function(model, border) {
  grad <- c(1, 1)
  
  if(border > 0) {
    term <- paste0("ind_treat:factor(border)", border)
    
    vb <- m$clustervcv[c("ind_treat", term), c("ind_treat", term)]
    vG <- t(grad) %*% vb %*% grad
    
    se <- sqrt(vG)
    sum <- coef(m)["ind_treat"] + coef(m)[term]
  } else {
    se <- summary(m)$coefficients["ind_treat", "Cluster s.e."]
    sum <- summary(m)$coefficients["ind_treat", "Estimate"]
  }
  
  return(c(sum, se))
}

#================================================================
m <- felm(ind_protest ~ ind_treat * factor(border) |
    cell_number_5x5 + country_year | 0 | cell_number_5x5,
  data = brdr_dt)

res_p_dt <- lapply(0:5, SumCoef, model = m) %>%
  do.call(rbind, .) %>%
  data.table()
setnames(res_p_dt, c("est", "se"))

res_p_dt[, dist := 0:5]
res_p_dt[, y := "protest"]

#================================================================

m <- felm(ind_rebel_event ~ 
    ind_treat * factor(border) |
    cell_number_5x5 + country_year | 0 | cell_number_5x5,
  data = brdr_dt)

res_reb_dt <- lapply(0:5, SumCoef, model = m) %>%
  do.call(rbind, .) %>%
  data.table()
setnames(res_reb_dt, c("est", "se"))

res_reb_dt[, dist := 0:5]
res_reb_dt[, y := "rebel"]

#================================================================

m <- felm(ind_battle ~ 
    ind_treat * factor(border) |
    cell_number_5x5 + country_year | 0 | cell_number_5x5,
  data = brdr_dt)

res_bat_dt <- lapply(0:5, SumCoef, model = m) %>%
  do.call(rbind, .) %>%
  data.table()
setnames(res_bat_dt, c("est", "se"))

res_bat_dt[, dist := 0:5]
res_bat_dt[, y := "battle"]

#================================================================

res_dt <- rbindlist(list(res_p_dt, res_reb_dt, res_bat_dt))

# Adding CIs:
res_dt[, ub95 := est + 1.96 *se]
res_dt[, lb95 := est - 1.96 *se]
res_dt[, ub90 := est + 1.64 *se]
res_dt[, lb90 := est - 1.64 *se]

res_dt[, dist := as.numeric(dist)]
res_dt[y == "battle", dist := dist - .2]
res_dt[y == "rebel", dist := dist + .2]

pdf(file = "figures/figure-3b.pdf")
ggplot(data = res_dt, 
  aes(x = dist, y = est, color = y, shape = y)) +
  geom_hline(yintercept = 0, lty = 2) + 
  geom_linerange(aes(ymin = lb95, ymax = ub95)) +
  geom_linerange(aes(ymin = lb90, ymax = ub90), size = 1) +
  geom_point(size = 3) + 
  scale_y_continuous(expression(paste(hat(beta)[DiD]))) +
  scale_shape_discrete("", labels = c("Battle", "Protest", "Rebel Event")) + 
  scale_color_manual("", 
    labels = c("Battle", "Protest", "Rebel Event"), 
    values = c("grey50", "black", "grey70")) + 
  scale_x_continuous("Border Region", 
    breaks = 0:5,
    labels = c("M", 1:5)) +
  theme_bw() + opts + 
  guides(shape = guide_legend(nrow = 1), color = guide_legend(nrow = 1)) + 
  theme(legend.position = c(.5, .75))
dev.off()