library(readxl)
library("magrittr")
library("plyr")
library(tidyverse)
library(openxlsx)

#function to be used to change date format later
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

# Section One - Combine Data ------------------------------------------------------------

setwd("C:/Users/Andrei/OneDrive/ETH Zurich/IMPACT Initiatives/Official data")


#get tab name of each month of data
tabs=getSheetNames("AK mod_MM_for_nov17_aug19.xlsx")

#combine all data into one matrix
for (tab in tabs){
  
  #call custom function for grouping data at the subdistrict level and 
  #calculating SMEBs (where the SMEB calculation is done using IMPACT's function)
  data_wsmeb<-calculate_sbd_smeb("AK mod_MM_for_nov17_aug19.xlsx",tab)
  
  #add row to matrix
  if (which(tabs==tab)==1){
    combined_data <- cbind(month=rep(tab,nrow(data_wsmeb)), data_wsmeb)
  } else{
    combined_data <- rbind(combined_data, cbind(month=rep(tab,nrow(data_wsmeb)), data_wsmeb))
  }
}
#change dates to be in YYYY-MM format
combined_data$month<-paste("20",substrRight(combined_data$month,2),"-",sprintf("%02d", match(substr(combined_data$month, 1, 3),month.abb)), sep="")