# figure 3a

rm(list = ls()); gc()

BCells <- function(t, x, ncol) {
  bcells <- c(
    t + x + 0:x * ncol,
    t + x - 0:x * ncol,
    t - x + 0:x * ncol,
    t - x - 0:x * ncol,
    t + 0:(x-1) + x * ncol,
    t + 0:(x-1) - x * ncol,
    t - 0:(x-1) + x * ncol,
    t - 0:(x-1) - x * ncol
  ) %>% unique()
  bcells
}

mat <- matrix(0, nrow = 11, ncol = 11)
for(i in 1:5) {
  mat[BCells(t = 61, x = i, ncol = 11)] <- i
}

reg_dt <- data.table(melt(mat)); rm(mat)
setnames(reg_dt, c("row", "column", "dist"))
i <- 5

pdf(file = "figures/figure-3a.pdf")
ggplot(data = reg_dt[dist <= 5],
  aes(x = row, y = column, fill = dist)) +
  geom_tile(color = "white") +
  annotate("text", x = 6, y = 6, label = "M", color = "black",
    fontface = "bold", family = "serif", size = 6) +
  annotate("text", x = c(7:(6 + i)), y = 6, label = c(1:i), 
    color = "black", fontface = "bold", family = "serif", size = 6) +
  annotate("text", y = c(7:(6 + i)), x = 6, label = c(1:i), 
    color = "black", fontface = "bold", family = "serif", size = 6) +
  scale_x_continuous("Kilometers from Mining Cell (M)", 
    breaks = seq(1, 11, 2), 
    labels = abs(seq(-25, 25, by = 10)), 
    limits = c(.5, 11.5)) +
  scale_y_continuous("Kilometers from Mining Cell (M)", 
    breaks = seq(1, 11, 2), 
    labels = abs(seq(-25, 25, by = 10)), 
    limits = c(.5, 11.5)) +
  scale_fill_gradient2("Region", low = muted("red"), high = "grey40",
    midpoint = 0, space = "Lab", guide = FALSE) +
  coord_equal() +
  theme_bw() + opts + theme(legend.position = "top") +
  theme(axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14))
dev.off()