Preamble <- function(install) {
  #================================================================
  # Loading Packages
  
  pkgs <-
    c(
      "raster",
      "geosphere",
      "rgeos",
      "maptools",
      "scales",
      "rgdal",
      "grid",
      "gridExtra",
      "extrafont",
      "ggplot2",
      "stringr",
      "lubridate",
      "lfe",
      "stargazer",
      "readxl",
      "readr",
      "sf",
      "dplyr",
      "data.table"
    )
  if(install){suppressMessages(sapply(pkgs, install.packages, character.only = TRUE))}
  suppressMessages(sapply(pkgs, require, character.only = TRUE))
  
  #================================================================
  # Defining Directories
  .env <- new.env()
  
  # Plotting Options:
  .env$opts <- theme(
    text = element_text(family = "Times"),
    panel.grid.major = element_line(colour = 'transparent'),
    panel.grid.minor = element_line(colour = 'transparent'),
    strip.background = element_rect(colour = 'grey', fill = 'transparent'),
    # panel.border = element_rect(color = 'transparent'),
    panel.spacing = unit(.5, "cm"),
    strip.text = element_text(size = 16, colour = 'black'),
    axis.text.x = element_text(size = 18, colour = 'black'),
    axis.text.y = element_text(size = 18, colour = 'black'),
    axis.title.x = element_text(size = 18, colour = 'black'),
    title = element_text(size = 16, colour = 'black'),
    axis.title.y = element_text(
      size = 18,
      angle = 90,
      colour = 'black',
      vjust = 1.1
    ),
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 16)
  )
  
  .env$map_theme <- theme(
    text = element_text(family = "Times"),
    panel.grid.major = element_line(colour = 'transparent'),
    panel.grid.minor = element_line(colour = 'transparent'),
    strip.background = element_rect(colour = 'grey', fill = 'transparent'),
    # panel.border = element_rect(color = 'transparent'),
    panel.spacing = unit(.5, "cm"),
    axis.line = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    title = element_text(size = 14, colour = 'black'),
    panel.background = element_rect(fill = 'transparent', colour = NA)
  )
  
  attach(.env, warn.conflicts = FALSE)
}
