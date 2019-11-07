# INPUTS: 
# data that is an output of the function aggregate_price_geogr

# OUTPUT:
# A table with a record for each month and each unique record for the 
# specified geographical level (i.e., if subdistrict is specified, since
# there are 114 unique subdistricts the output table will have 
# 22 (num unqique months) * 114 = 2508 rows)
# Price data will be filled in if the data exists for that month

#Need the following libraries:
library(zoo)

complete_data<-function(data){
  
  #set up a vector with all months existing in the data set
  data$Month=as.yearmon(data$Month, "%b %y")
  unq_months<-unique(data$Month)
  unq_months<-sort(unq_months)
  
  #determine the non-price columns in the data
  non_price_col_names <- c("region", "q_gov", "q_district", "q_sbd", "q_town")
  columns_to_put<-non_price_col_names[non_price_col_names %in% colnames(data)]
  
  #unique combination of the non-price columns
  wo_month<-unique(data[,c(columns_to_put)])
  
  #make a table with every possible month for every unique combination of the
  #non-price columns that is in the data
  all_combinations<-merge(unq_months, wo_month)
  colnames(all_combinations)[1] <- "Month"
  
  #set up the columns for joining
  nonprice_col_plus_month <- c("Month", "region", "q_gov", "q_district", "q_sbd", "q_town")
  columns_to_join_on <- nonprice_col_plus_month[nonprice_col_plus_month %in% colnames(data)]
  
  #join the created table with the data
  completed_data <- merge(all_combinations, data, by=columns_to_join_on, all.x=TRUE)
  
  return(completed_data)
}
