# figure 2a

rm(list = ls()); gc()

brdr_dt <- readRDS("data/did-acled-border.rds")

#================================================================
## Figure 2a:
#================================================================

plot_dt <- brdr_dt[border <= 2]
plot_dt[is.na(min_year), min_year := 2015L]
treat_grps <- plot_dt[min_year != 2015, sort(unique(min_year))]

# Averages by Treatment Group, Treatment, and Year:
dt_list <- list()
for(t in seq_along(treat_grps)) {
  temp_dt <- plot_dt[min_year >= treat_grps[t]]
  temp_dt[, treat := as.integer(min_year == treat_grps[t])]
  
  dt_list[[t]] <- temp_dt[, list(
    .N,
    pr_protest = mean(ind_protest),
    group = treat_grps[t]),
    by = list(treat, year)]    
}
plot_dt <- rbindlist(dt_list)

# Relative Year:
plot_dt[, rel_year := year - group]

# Average by relative year and treatment:
plot_dt <- plot_dt[, list(
  N = sum(N),
  pr_protest = mean(pr_protest)),
  by = list(rel_year, treat)][order(treat, rel_year)]

plot_dt[, post := as.integer(rel_year < 0)]
plot_dt[, grp := paste0(treat, "_", post)]

pdf(file = "figures/figure-2a.pdf")
ggplot(data = plot_dt[rel_year %in% -7:14],
  aes(x = rel_year, y = pr_protest, color = factor(treat))) +
  geom_rect(xmin = 0, xmax = 15, ymin = 0, ymax = 0.4,
    fill = "grey90", color = "transparent", alpha = 0.2) +
  geom_hline(yintercept = 0) +
  geom_smooth(aes(group = grp), method = "lm", se = FALSE, lwd = 1) +
  geom_line(alpha = .1, lwd = .5) +
  geom_point() +
  scale_color_manual(guide = FALSE, values = c("grey50", "black")) +
  scale_x_continuous("Years Since Mining", breaks = seq(-7, 14, 7)) +
  scale_y_continuous("Pr(Protest or Riot)", limits = c(0, .06)) +
  annotate("text", x = 7, y = .04, label = "T:Mining Cells",
    size = 5, color = "black", family = "serif") +
  annotate("text", x = 7, y = .007, label = "C:Border Cells",
    size = 5, color = "grey50", family = "serif") +
  theme_bw() + opts
dev.off()

