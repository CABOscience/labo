### Code to prepare ICP data for Fulcrum import
## Etienne Laliberté, Nov 19, 2020
# Using SWA-Warren as an example (one single batch, .xlsx file)
# Actual file sent by STRI


### Load required libraries (install if needed) ---
# library(googlesheets4)
library(tidyverse)
library(readxl)


### Step 1: Parameters to define ----
# Name of .xlsx file with ICP data from STRI
file_name <- "Etienne Agonis total elements.xlsx"

# Name of file for export (.csv)
file_name_export <- "2020-03-01-SWA-Warren-ICP.csv"
  
# Date of measurement (must be YYYY-MM-DD)
date_measured <- "2020-03-01" # approximate date
measured_by <- "Dayana Agudo, Sabrina Demers-Thibeault"

# Project
project <- "SWA-Warren"

# Default Record status
status <- "verified"


### Step 2: Read file and select/rename columns -----
icp_data <- read_excel(file_name) %>% 
  slice(-1, -2) %>% # remove two lines with units and empty row
  select(-`Scientific name`) %>%  # remove scientific name column, not needed
  rename(sample_id = Sample_id, # rename columns
         al_mg_g = Al,
         ca_mg_g = Ca,
         cu_mg_g = Cu,
         fe_mg_g = Fe,
         k_mg_g = K,
         mg_mg_g = Mg,
         mn_mg_g = Mn,
         na_mg_g = Na,
         ni_mg_g = Ni,
         p_mg_g = P,
         zn_mg_g = Zn) %>% 
  mutate_if(is.character,
            str_replace_all, pattern = "^<", replacement = "") %>% # remove < for below detection limit
  mutate_all(as.double) %>% # convert values to numeric
  mutate(sample_id = as.character(sample_id)) # sample_id should be character


### Step 3: Load Leaf Chemistry Samples Fulcrum records ----
chem <- read_csv("https://web.fulcrumapp.com/shares/cde2fbb1ccc879a2.csv") %>% # Fulcrum data share
  select(leaf_chemistry_sample = fulcrum_id,
         sample_id) %>%
  mutate(sample_id = as.character(sample_id)) # convert from dbl to chr

#### Step 4: Join the two tables together and add Date + Person -----
icp_data_sample <- icp_data %>% # start with cn_data
  inner_join(chem, # join to chem samples
            na_matches = "never") %>% # remove na matches
  mutate(date_measured = as.Date(date_measured), # add date measured
         measured_by, # add measured by
         project, # add project
         status)# add record status

#### Step 5: Save as .csv file for import into Fulcrum
write_csv(icp_data_sample,
          path = paste0("fulcrum_import_", file_name_export))

