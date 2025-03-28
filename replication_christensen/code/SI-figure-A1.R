# figure A.1

rm(list = ls()); gc()

gov_pnl <- readRDS("data/wgi-eiti-country-year.rds")

# WGI Variables
vars <- c("voice", "stability", "effective", "regulation", "rol", "corruption")

# Correlation Matrix:
cor_dt <- gov_pnl[, c("candidate", vars), with = FALSE] %>%
  cor(use = "complete.obs") %>%
  data.table()

cor_dt[, var := c("candidate", vars)]

# Reshaping and ordering:
cor_dt <- melt(cor_dt, id.vars = "var")
cor_dt[, var := factor(var, levels = c("candidate", vars))]
cor_dt[, variable := factor(variable, levels = c("candidate", vars))]

var_labels <- c("Candidate", "Voice", "Stability", "Rule of Law", "Regulation", "Effectiveness", "Corruption")

pdf(file = "figures/SI-figure-A1.pdf")
ggplot(data = cor_dt, aes(x = var, y = variable, fill = value)) + 
  geom_tile() + 
  geom_text(aes(label = round(value, 2), color = value), family = "mono", size = 5) + 
  scale_fill_gradient(high = "white", low = "black", limits = c(-.2, 1),
    guide = FALSE) + 
  scale_color_gradient(high = "black", low = "white", limits = c(-.2, 1),
    guide = FALSE) + 
  scale_y_discrete("", labels = var_labels) + 
  scale_x_discrete("", labels = var_labels) + 
  theme_bw() + opts + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
dev.off()