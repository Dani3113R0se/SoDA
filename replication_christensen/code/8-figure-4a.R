# figure 4a 

rm(list = ls()); gc()

price_dt <- readRDS("data/prices.rds")
wt_dt <- readRDS("data/prices-plot-weights.rds")

pdf(file = "figures/figure-4a.pdf")
ggplot(price_dt[year %in% 1990:2013 & usgs_name != "TANTALUM"],
  aes(x = year)) +
  geom_line(
    aes(y = wb_pct_base, group = usgs_name), 
    alpha = .2) +
  geom_smooth(aes(y = wb_pct_base, weight = N / wt_dt[, sum(N)]),
    method = "loess", se = TRUE,
    lwd = 1.5, color = "black", fill = "black", alpha = .2) +
  geom_hline(yintercept = c(1, 3), lty = 3, color = "black") +
  scale_x_continuous("\n", breaks = c(1990, 1995, 2000, 2005, 2010, 2013)) +
  scale_y_continuous("Price / Price in 1990", breaks = seq(-1,3,1)) +
  coord_cartesian(ylim = c(0.5, 4)) +
  theme_bw() + opts +
  theme(legend.position = "bottom")
dev.off()