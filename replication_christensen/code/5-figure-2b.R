# figure 2b

rm(list = ls()); gc()

pnl_dt <- readRDS("data/did-acled.rds")
pnl_dt <- pnl_dt[year <= (min_year + 15) | is.na(min_year)]
# pnl_dt <- pnl_dt[never_mine == 0]

#================================================================
# Defining leads and lags:
pnl_dt[, switch := as.integer(year == min_year)]

# Number of leads/lags:
num_lags <- 10

RHS_lead <- paste0("lead(switch, ", 1:num_lags, ", order_by = year)") %>%
  paste(collapse = ", ") %>%
  paste0("list(", ., ")")

# Generating Leads:
pnl_dt[!is.na(switch),
  paste0("lead", 1:num_lags) := eval(parse(text = RHS_lead)),
  by = cell_number_5x5]

RHS_lag <- paste0("lag(switch, ", 1:num_lags, ", order_by = year)") %>%
  paste(collapse = ", ") %>%
  paste0("list(", ., ")")

# Generating Lags:
pnl_dt[!is.na(switch),
  paste0("lag", 1:num_lags) := eval(parse(text = RHS_lag)),
  by = cell_number_5x5]

col_nums <- grep("lead|lag|switch", names(pnl_dt))
for(i in col_nums) {
  set(pnl_dt, i = which(is.na(pnl_dt[[i]])), j = i, value = 0)
}

# Adding all years > biggest lag to the final lag:
pnl_dt[never_mine == 0, last_year := year[lag10 == 1],
  by = cell_number_5x5]
pnl_dt[year >= last_year & !is.na(last_year), lag10 := 1L]
pnl_dt[, last_year := NULL]

#================================================================
# Combining the leads/lags into two year indicators:

pnl_dt[, lag_int1 := as.integer(lag1 == 1 | lag2 == 1)]
pnl_dt[, lag_int2 := as.integer(lag3 == 1 | lag4 == 1)]
pnl_dt[, lag_int3 := as.integer(lag5 == 1 | lag6 == 1)]
pnl_dt[, lag_int4 := as.integer(lag7 == 1 | lag8 == 1)]
pnl_dt[, lag_int5 := as.integer(lag9 == 1 | lag10 == 1)]

pnl_dt[, lead_int1 := as.integer(lead1 == 1 | lead2 == 1)]
pnl_dt[, lead_int2 := as.integer(lead3 == 1 | lead4 == 1)]
pnl_dt[, lead_int3 := as.integer(lead5 == 1 | lead6 == 1)]
pnl_dt[, lead_int4 := as.integer(lead7 == 1 | lead8 == 1)]
pnl_dt[, lead_int5 := as.integer(lead9 == 1 | lead10 == 1)]

num_int <- 5

#================================================================
form <- paste("ind_protest ~", 
  paste(c(
    paste0("lag_int", num_int:1), 
    "switch", 
    paste0("lead_int", 1:num_int)), collapse = " + "), 
  "| cell_number_5x5 + year | 0 | cell_number_5x5")

m <- felm(as.formula(form), data = pnl_dt)
summary(m)

plot_dt <- data.table(
  num = num_int:-num_int,
  data.table(summary(m)$coefficients))
setnames(plot_dt, c("num", "est", "se", "t", "p"))
plot_dt[, coef := rownames(summary(m)$coefficients)]

plot_dt[, num := as.numeric(num)]
plot_dt[num > 0, num := num * 2 - 0.5]
plot_dt[num < 0, num := num * 2 + 0.5]
plot_dt[, lb_95 := est - 1.96 * se]
plot_dt[, lb_90 := est - 1.64 * se]
plot_dt[, ub_95 := est + 1.96 * se]
plot_dt[, ub_90 := est + 1.64 * se]
plot_dt[, post := as.integer(num >= 0)]

pdf(file = "figures/figure-2b.pdf")
ggplot(data = plot_dt,
  aes(x = num, y = est, color = factor(post))) +
  geom_rect(aes(xmin = -0.2, xmax = 10, ymin = -.01, ymax = .04), 
    fill = "grey90", color = "transparent") +
  geom_hline(yintercept = 0, lty = 1, lwd = 1) +
  geom_linerange(aes(ymin = lb_95, ymax = ub_95), size = .4) +
  geom_linerange(aes(ymin = lb_90, ymax = ub_90), size = 1) +
  scale_color_manual(breaks = c(0, 1), values = c("grey50", "black"), 
    guide = FALSE) +
  coord_cartesian(ylim = c(-.01, .04)) +
  ylab("Estimate") +
  xlab("Years Before and After Mining") +
  theme_bw() + opts
dev.off()