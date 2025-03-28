Concession Stands:
How Mining Investments Incite Protest in Africa

Darin Christensen (darinc@luskin.ucla.edu)
February 18, 2018 

% ================================================================

TABLE OF CONTENTS/
  
The folder contains four sub-directories: (1) code, (2) data, (3) figures, and (4) tables. It also contains an R profile file (*.rproj); opening this file in RStudio will be the simplest way to work with the code and data files, as there will be no need to further specify working directories. 

CODE/
  
The code directory contains the scripts needed to reproduce every figure and table in both the body of the paper and the supporting information. (Scripts that being with SI* correspond to figures and tables from the supporting information.)

To reproduce any of the figures or tables, open 0_master.R. At the top of this script, you'll load the Preamble() function. This function also loads all the R packages needed for the subsequent analysis. If you have not already installed these packages, change the only argument of Preamble() to install = TRUE. 

Each script is named for the table or figure that it reproduces in the text. 2_figure_2a.R, for example, reproduces figure 2a. (The numbers before the first underscore order the scripts in terms of when the figure or table appears in the manuscript.) 

DATA/

The data directory contains datasets required to reproduce the figures and tables. All datasets are saved as *.rds files. I have tried to give the datasets informative titles, but their contents can be easily discerned by looking through the scripts; nearly every code file begins by clearing the workspace and loading one of these datasets.

The data I use on mining projects is proprietary. To protect the provider's intellectual property, I had to scramble the cell identifiers, effectively removing all location information. As we note in 0_master.R, I separately anonymized the different analysis datasets as we created the replication archive, so cell IDs are NOT the same across datasets. Users should not attempt to merge on the variable raster_cell_number across datasets.

FIGURES/

Folder for the figures produced by the scripts. All figures are produced as PDFs.

As we note in 0_master.R, the data used to produce figure 1 is proprietary and cannot be included in the replication archive.

TABLES/

Folder for the tables produced by the scripts. All tables are produced as tex files.

SESSION INFO/

R version 3.3.3 (2017-03-06)
Platform: x86_64-apple-darwin13.4.0 (64-bit)
Running under: macOS  10.13.3

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] grid      stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] data.table_1.10.5  dplyr_0.7.4        sf_0.5-5           readr_1.1.1       
 [5] readxl_1.0.0       stargazer_5.2      lfe_2.5-1998       Matrix_1.2-12     
 [9] lubridate_1.7.1    stringr_1.2.0      ggplot2_2.2.1.9000 extrafont_0.17    
[13] gridExtra_2.3      rgdal_1.2-15       scales_0.5.0.9000  maptools_0.9-2    
[17] rgeos_0.3-26       geosphere_1.5-7    raster_2.6-7       sp_1.2-5          

loaded via a namespace (and not attached):
 [1] zoo_1.8-0        reshape2_1.4.2   lattice_0.20-35  colorspace_1.3-2 yaml_2.1.14     
 [6] rlang_0.1.4      e1071_1.6-8      foreign_0.8-69   glue_1.2.0       DBI_0.7         
[11] bindrcpp_0.2     plyr_1.8.4       bindr_0.1        munsell_0.4.3    gtable_0.2.0    
[16] cellranger_1.1.0 labeling_0.3     class_7.3-14     Rttf2pt1_1.3.4   Rcpp_0.12.13    
[21] xtable_1.8-2     udunits2_0.13    classInt_0.1-24  digest_0.6.12    hms_0.3         
[26] stringi_1.1.6    tools_3.3.3      sandwich_2.4-0   magrittr_1.5     lazyeval_0.2.1  
[31] tibble_1.3.4     Formula_1.2-2    extrafontdb_1.0  pkgconfig_2.0.1  assertthat_0.2.0
[36] R6_2.2.2         units_0.4-6    