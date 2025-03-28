install.packages("haven")
install.packages("ggplot2")
install.packages("dplyr")

library(haven)
library(ggplot2)
library(dplyr)

data <- read_dta("sps_main.dta")
data$date <- as.Date(paste(as.character(data$ym),"01",sep=""), "%Y%m%d")

# Figure 1: Monthly Cases of Food and Cosmetics Imports Refusals, 2011-2019

korea <- subset(data, country_name == "South Korea")

thaad <- data.frame(xmin=as.Date('2016-07-01'), 
                    xmax=as.Date('2017-10-30'), 
                    ymin=-Inf, 
                    ymax=Inf)

pdf("Figure1-a.pdf", width=9, height=5)

ggplot() +
  geom_bar(data = korea, aes(x = date, y = sps_cosmetics_measures), stat='identity', position = 'dodge') +
  geom_rect(data = thaad, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), alpha = 0.4) + 
  theme_bw() +
  theme(legend.position="bottom") +
  scale_x_date(expand = c(0,0), date_breaks = "1 year", labels = function(x) substr(as.character(x), 1, 7), date_minor_breaks = "1 month") +
  theme(legend.position="bottom") + 
  xlab("") + ylab("") + guides(fill=guide_legend(title=""))

dev.off()

pdf("Figure1-b.pdf", width=9, height=5)

ggplot() +
  geom_bar(data = korea, aes(x = date, y = sps_food_measures), stat='identity', position = 'dodge') +
  geom_rect(data = thaad, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), alpha = 0.4) + 
  theme_bw() +
  theme(legend.position="bottom") +
  scale_x_date(expand = c(0,0), date_breaks = "1 year", labels = function(x) substr(as.character(x), 1, 7), date_minor_breaks = "1 month") +
  theme(legend.position="bottom") + 
  xlab("") + ylab("") + guides(fill=guide_legend(title=""))

dev.off()

# Figure 3: Monthly counts of food import refusals by countries.

data <- data %>% 
  group_by(country_name) %>% 
  mutate(total_food_measures = sum(sps_food_measures))

selected <- subset(data, total_food_measures > 200)

selected$sps_food_measures <- ifelse(selected$sps_food_measures > 100, 100, selected$sps_food_measures)

selected$country_name <- gsub("United States", "US", selected$country_name)
selected$country_name <- gsub("United Kingdom", "UK", selected$country_name)

pdf("Figure3.pdf", width=10, height=6)

ggplot(selected, aes(date, country_name)) + geom_tile(aes(fill=sps_food_measures), color = "gray") + 
  scale_fill_gradient(low="white", high="steelblue", name = "", labels=c("0", "25", "50", "75", "100+")) + theme(axis.text = element_text(size = 13), legend.text=element_text(size=12)) + labs(x = "", y = "") + 
  theme(legend.position = "bottom") + scale_y_discrete(expand=c(0, 0)) + scale_x_date(expand=c(0, 0))

dev.off()

# Figure A1: GDELT Conflict Scores Involving Military Actors, 2011-2019

country_list <-  c("Japan", "Philippines", "Taiwan", "United States")

for (i in c(1:length(country_list))) {

    subset <- data[data$country_name %in% country_list[i], ]
    gdelt_subset <- subset[c('country_name', 'date', 'gdelt_gs_conf_mil_nonecon')]
    
pdf(paste("FigureA1-", country_list[i], ".pdf", sep =""), width=9, height=5)

plot <- ggplot(gdelt_subset, aes(x = date, y = gdelt_gs_conf_mil_nonecon)) +
  geom_line() +
  #ggtitle(country_list[i]) + 
  theme_bw() +
  theme(legend.position="bottom") +
  scale_x_date(date_breaks = "1 year", labels = function(x) substr(as.character(x), 1, 7), date_minor_breaks = "1 month") +
  theme(legend.position="bottom") + 
  xlab("") + ylab("") + guides(fill=guide_legend(title=""))

print(plot)
dev.off()

}


# Figure A2: Import Refusals & GDELT Conflict Scores, South Korea

pdf("FigureA2-a.pdf", width=9, height=5)

ggplot(korea) +
  geom_bar(aes(x = date, y = sps_cosmetics_measures), stat='identity', position = 'dodge', fill='tomato3') +
  geom_line(aes(x = date, y = gdelt_gs_conf_mil_nonecon/10)) +
  scale_y_continuous(
    name = "Cosmetics Import Refusals (Bar)",
    sec.axis = sec_axis(~.*10, name = "GDELT Conflict Score (Line)")
  ) + 
  labs(y.sec = "GDELT Conflict Score") +
  theme_bw() +
  theme(legend.position="bottom") +
  scale_x_date(expand = c(0,0), date_breaks = "1 year", labels = function(x) substr(as.character(x), 1, 7), date_minor_breaks = "1 month") +
  theme(legend.position="bottom") + 
  xlab("") + ylab("") + guides(fill=guide_legend(title="")) + 
  theme(
    axis.title.y = element_text(color = "tomato3", angle = 90, vjust = 0.5, hjust = 0.5),
    axis.title.y.right = element_text(color = "black", angle = 90, vjust = 0.5, hjust = 0.5)
  )

dev.off()

pdf("FigureA2-b.pdf", width=9, height=5)

ggplot(korea) +
  geom_bar(aes(x = date, y = sps_food_measures), stat='identity', position = 'dodge', fill='tomato3') +
  geom_line(aes(x = date, y = gdelt_gs_conf_mil_nonecon/10)) +
  scale_y_continuous(
    name = "Food Import Refusals (Bar)",
    sec.axis = sec_axis(~.*10, name = "GDELT Conflict Score (Line)")
  ) + 
  labs(y.sec = "GDELT Conflict Score") +
  theme_bw() +
  theme(legend.position="bottom") +
  scale_x_date(expand = c(0,0), date_breaks = "1 year", labels = function(x) substr(as.character(x), 1, 7), date_minor_breaks = "1 month") +
  theme(legend.position="bottom") + 
  xlab("") + ylab("") + guides(fill=guide_legend(title="")) + 
  theme(
    axis.title.y = element_text(color = "tomato3", angle = 90, vjust = 0.5, hjust = 0.5),
    axis.title.y.right = element_text(color = "black", angle = 90, vjust = 0.5, hjust = 0.5)
  )

dev.off()

