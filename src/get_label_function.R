#' Assign a label (stable, trend, volatile or volatile trend) to a commodity type 
#' for a specific region based on the price developement over the past months
#' 
#' @return a label which classifies the price of a commoditiy as stable, trend, volatile or volatile trend
#' @inheritParams indicators

library(tidyverse)

get_label_from_raw_table <- function(df, final_month,  time_window=6, frac_missing=0.2, 
                                     geo_level = 'q_district', commodity_type = 'smeb_total_float'){
  source('src/get_aggregated_table.R')
  df = get_aggregated_table(df, geo_level = geo_level, commodity_type = commodity_type,
                            final_month = final_month, time_window = time_window)
  
  label_df = get_label(df, frac_missing = frac_missing, 
                       geo_level = geo_level, commodity_type = commodity_type)
  
  return(label_df)
}

geo_level = 'q_district'


get_label<- function(df, frac_missing=0.2, 
                     geo_level = 'q_district', commodity_type = 'smeb_total_float'){
  
  source("src/get_derivative.R")
  geogr_units = unique(df[[geo_level]])
  
  label_df_list = list()
  for (location in geogr_units){
    new_df = get_label_per_location(df, geo_level, location, commodity_type)
    label_df_list[[location]] = new_df
  }
  label_df = do.call(rbind, label_df_list)
  
  # return a data frame with labels or trend characteristics
  return(label_df)
}
  

get_label_per_location <- function(df, geo_level, location, commodity_type) {
  # Step 1
  df_price_vector = df[which(df[[geo_level]] == location), ]
  price_vector = df_price_vector[[commodity_type]]
  mean_price = mean(price_vector, na.rm = T)
  
  derivative_vector <- get_derivative(price_vector)
  # Step 2
  source("src/aggregate_quantity.R")
  aggr_stats <- aggregate_quantity(derivative_vector)
  sd_der = aggr_stats$sd
  mean_der = aggr_stats$mean
  n_missing_der = aggr_stats$n_missing
  frac_missing_der = aggr_stats$frac_missing
  n_der = aggr_stats$n
  
  
  # return a vector with the standard deviation, the mean and the number of missing price points
  
  # Step 3
  # source("src/assign_label.R")
  # new_df$label <- assign_label(new_df, thres=NULL, frac_missing = frac_missing)
  # return label
  
  #assemble it all into the dataframe
  new_df = data.frame(location = location, sd_der = sd_der, mean_der = mean_der, 
                      n_missing_der = n_missing_der, frac_missing_der = frac_missing_der,
                      n_der = n_der, mean_price = mean_price)
  names(new_df)[1] = geo_level
  return(new_df)
}
