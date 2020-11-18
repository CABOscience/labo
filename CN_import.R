### Code to prepare C/N data for Fulcrum import
## Etienne Laliberté, Nov 18, 2020
# Using SWA-Warren as an example (one single batch, .csv file)


### Load required libraries (install if needed) ---
# library(googlesheets4)
library(tidyverse)
library(googledrive)


### Step 1: Parameters to define ----
# Name of .csv file with C/N data exported from analyzer
file_name <- "2019-02-14_CABO_Warren.csv"

# Date of measurement (must be YYYY-MM-DD)
date_measured <- "2019-02-14"
measured_by <- "Sabrina Demers-Thibeault"

# Project
project <- "SWA-Warren"

# Default Record status
status <- "verified"


### Step 2: Download .csv file from Google Drive ----
drive_auth() # grant authorization to LEFO drive
drive_download(file_name,
               overwrite = TRUE) # if file already exists


### Read .csv file and select/rename columns -----
cn_data <- read_delim(file_name,
                      delim = ";", # default separator is ;
                      skip = 1, # first line sep=; to skip
                      trim_ws = TRUE) %>% # remove leading and trailing white spaces
  select(sample_id = Name, # select and rename Name
         c_perc = `C  [%]`, # 2 white spaces!! ;)
         n_perc = `N [%]`) # 1 white space...


### Step 3: Load Leaf Chemistry Samples Fulcrum records ----
chem <- read_csv("https://web.fulcrumapp.com/shares/cde2fbb1ccc879a2.csv") %>% # Fulcrum data share
  select(leaf_chemistry_sample = fulcrum_id,
         sample_id) %>%
  mutate(sample_id = as.character(sample_id)) # convert from dbl to chr

#### Step 4: Join the two tables together and add Date + Person -----
cn_data_sample <- cn_data %>% # start with cn_data
  inner_join(chem, # join to chem samples
            na_matches = "never") %>% # remove na matches
  mutate(date_measured = as.Date(date_measured), # add date measured
         measured_by, # add measured by
         project, # add project
         status)# add record status

#### Step 5: Save as .csv file for import into Fulcrum
write_csv(cn_data_sample,
          path = paste0("fulcrum_import_", file_name))

