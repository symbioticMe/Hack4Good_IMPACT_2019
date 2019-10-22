#library(readxl)
library("magrittr")
library("plyr")
library(tidyverse)
#library(openxlsx)

# Section One - Create SMEB data frames at sbd and town level ------------------------------------------------------------

setwd("C:/Users/Andrei/OneDrive/ETH Zurich/IMPACT Initiatives")

#read in csv with all data
aggregated_data <- read.csv(file="aggregated_monthly_1.csv", header=TRUE, sep=",")

#group prices at the sbd level (taking median) and calculate smeb
SMEB_sbd_level <- calculate_sbd_smeb(aggregated_data)

#group prices at the town level (taking median) and calculate smeb
SMEB_town_level <- calculate_town_smeb(aggregated_data)


# Section Two - Combine Two data frames -----------------------------------
sbd_level_df <- data.frame(Month=SMEB_sbd_level$Month, 
                           region=SMEB_sbd_level$region, 
                           q_gov=SMEB_sbd_level$q_gov, 
                           q_district=SMEB_sbd_level$q_district, 
                           q_sbd=SMEB_sbd_level$q_sbd,
                           sbd_smeb_complete=SMEB_sbd_level$smeb_complete,
                           sbd_smeb_only_missing_water=SMEB_sbd_level$smeb_only_missing_water,
                           sbd_smeb_total_float=SMEB_sbd_level$smeb_total_float,
                           sbd_smeb_sanswater_float=SMEB_sbd_level$smeb_sanswater_float,
                           sbd_smeb_incomplete=SMEB_sbd_level$smeb_incomplete,
                           sbd_smeb_usd=SMEB_sbd_level$smeb_usd)

combined_town_sbd<-merge(SMEB_town_level, sbd_level_df, 
                         by = c("Month","region","q_gov","q_district","q_sbd"))