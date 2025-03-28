#================================================================
## 0-master.R
#================================================================

rm(list = ls())
options(digits = 4)

# Load pacakges and define sub-directories:
source("code/_preamble.R")
# If you have not already installed the required pacakges, switch install = TRUE
Preamble(install = FALSE)

#================================================================

# NOTE 1:
# To remove proprietary location information we replace the cell numbers with random integers. For convenience we separately "anonymized" the different analysis datasets as we created the replication archive, so cell IDs are NOT the same across datasets. *Do not attempt to merge on the variable cell_number across datasets.* 

# NOTE 2:
# Several of these datasets are quite large and them models can require both plenty of memory and time to estimate. All code runs on my machine which is a late 2013 Mac Book Pro with 16 GB of memory.

#================================================================

# table 1:
source("code/1-table-1.R")

# table 2
source("code/2-table-2.R")

# table 3
source("code/3-table-3.R")

# figure 1:
# Code omitted; map cannot be reproduced w/o proprietary location information. 

# figure 2a:
source("code/4-figure-2a.R")

# figure 2b:
source("code/5-figure-2b.R")

# figure 3a:
source("code/6-figure-3a.R")

# figure 3b:
source("code/7-figure-3b.R")

# figure 4a:
source("code/8-figure-4a.R")

# figure 4b:
source("code/9-figure-4b.R")

# figure 5:
source("code/10-figure-5.R")

#================================================================
# Supporting information:

# table A.1:
source("code/SI-table-A1.R")

# table A.2:
source("code/SI-table-A2.R")

# table A.3:
source("code/SI-table-A3.R")

# table A.4:
source("code/SI-table-A4.R")

# table A.5:
source("code/SI-table-A5.R")

# table A.6:
source("code/SI-table-A6.R")

# table A.7:
source("code/SI-table-A7.R")

# table A.8:
source("code/SI-table-A8.R")

# table A.9:
source("code/SI-table-A9.R")

# table A.10:
source("code/SI-table-A10.R")

# table A.11:
source("code/SI-table-A11.R")

# table A.12:
source("code/SI-table-A12.R")

# table A.13:
source("code/SI-table-A13.R")

# table A.14:
source("code/SI-table-A14.R")

# table A.15:
source("code/SI-table-A15.R")

# table A.16:
source("code/SI-table-A16.R")

