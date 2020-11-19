# labo
Various scripts used to process the CABO lab data.

## CN_import.R
R script to:
1. download a `.csv` file exported from the C/N analyzer
2. add `leaf_chemistry_sample` Fulcrum ID to each sample
3. prepare table in Fulcrum format for import
4. create `.csv` file for importation into the Fulcrum **C/N: Leaf Concentrations** app

## ICP_import.R
R script to:
1. read an `.xlsx` file with ICP data from the lab
2. add `leaf_chemistry_sample` Fulcrum ID to each sample
3. prepare table in Fulcrum format for import
4. create `.csv` file for importation into the Fulcrum **ICP: Leaf Element Concentrations** app
