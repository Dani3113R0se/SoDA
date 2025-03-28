# figure 4b

rm(list = ls()); gc()

pnl_dt <- readRDS("data/did-price-acled.rds")

#================================================================

plot_dt <- pnl_dt[sum_mines > 0 & year <= 2013]

plot_dt[, mean_log_val := mean(log_val, na.rm = TRUE), by = cell_number_5x5]
plot_dt[, demean_log_val := log_val - mean_log_val]

plot_dt[, mean_ACLED := mean(ind_protest), by = cell_number_5x5]
plot_dt[, demean_ACLED := ind_protest - mean_ACLED]

qnt <- plot_dt[, quantile(demean_log_val, seq(0, 1, .1), na.rm = TRUE)]

plot_dt[, val_bin := cut(demean_log_val, qnt, include.lowest = TRUE)]
plot_dt[, val_bin_mid := val_bin %>% 
    str_replace_all("\\(|\\)|\\[|\\]", "") %>%
    str_split_fixed(",", n = 2) %>%
    apply(1, function(x) sum(as.numeric(x)) / 2)]

plot_dt[is.na(val_bin)]

pt_dt <- plot_dt[, list(
  .N, 
  pr_protest = mean(demean_ACLED, na.rm = TRUE),
  avg_price = mean(demean_log_val)),
  by = list(val_bin_mid)][order(val_bin_mid)]

pdf(file = "figures/figure-4b.pdf")
ggplot() +
  geom_smooth(data = plot_dt,
    aes(x = demean_log_val, y = demean_ACLED), lty = 1, 
    method = "lm", se = TRUE, lwd = 1, color = "black", alpha = .2, fullrange = TRUE) +
  geom_rug(data = plot_dt,
    aes(x = demean_log_val), alpha = .1) +
  geom_point(data = pt_dt, aes(x = val_bin_mid, y = pr_protest),
    color = "black", size = 3) +
  geom_point(data = pt_dt[9],
    aes(x = val_bin_mid, y = pr_protest),
    color = "black", size = 10, shape = 1) +
  annotate("text", x = .4, y = .0155, label = "Averages by Decile",
    family = "serif", fontface = "bold", size = 5) +
  scale_linetype_discrete("", guide = FALSE) +
  scale_y_continuous("Demeaned Protest", 
    breaks = c(-.025, 0, .025), expand = c(0.02, 0)) +
  scale_x_continuous("Demeaned Logged Prices", 
    expand = c(0.02, 0),
    breaks = seq(-1, 1, 1)) +
  coord_cartesian(ylim = c(-.025, .025), xlim = c(-1.15, 1.15)) +
  theme_bw() + theme(legend.position = "bottom") + opts +
  theme(axis.title.x = element_text(vjust = 0.1)) # +
# theme(plot.margin = unit(c(1,1.2,1.2,1.2),"lines"))
dev.off()