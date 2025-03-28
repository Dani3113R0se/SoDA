# figure 5

rm(list = ls()); gc()

gold_dt <- readRDS("data/gold-prices-cost.rds")

pdf(file = "figures/figure-5.pdf", width = 10, height = 4)
ggplot(data = gold_dt[year %in% 1979:2012], aes(x = year)) +
  geom_hline(yintercept = 1, color = "grey90") +
  geom_line(aes(y = wb_pct_base), color = "black", lwd = .7) +
  geom_line(aes(y = cost_pct_base), color = "black", lwd = 1, lty = 6) +
  geom_ribbon(data = gold_dt[year %in% 1979:2012],
    aes(x = year, ymin = ymin_red, ymax = ymax_red),
    alpha = .3, fill = "black") +
  annotate("text", x = 1982, y = 2.15, label = "World Price",
    family = "serif", fontface = "bold", size = 6) +
  annotate("text", x = 1996, y = 1.4, label = "Cash Costs",
    family = "serif", fontface = "bold", size = 6, color = "black") +
  annotate("text", x = 2005, y = 3, label = "Correlation = 0.89",
    family = "serif", size = 5) + 
  scale_x_continuous("", breaks = seq(1980, 2010, 10)) +
  scale_y_continuous("Value / Value in 1990", breaks = seq(-1,3,1)) +
  theme_bw() + opts
dev.off()