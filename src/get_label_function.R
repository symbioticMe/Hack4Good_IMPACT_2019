#' Assign a label (stable, trend, volatile or volatile trend) to a commodity type 
#' for a specific region based on the price developement over the past months
#' 
#' @return a label which classifies the price of a commoditiy as stable, trend, volatile or volatile trend
#' @inheritParams indicators

library(tidyverse)

get_aggregated_table <- function(){
  source("src/aggregate_price_geogr.R")
  df <- aggregate_price_geogr(df, geo_level, commodity_type)
  
  # take df and output df_aggr and complete it
  source('src/complete_data.R')
  df <- complete_data(df)
  
  #filter on time window
  source('src/filter_on_time_window.R')
  df <- filter_on_time_window(data = df, time_window = time_window, final_month = final_month)
}

get_label<- function(df, final_month, time_window=6, frac_missing=0.2, 
                     geo_level = 'q_district', commodity_type = 'smeb_total_float'){
  # Step 0
 
  
  # return a price vector
  
  
  
  source("src/get_derivative.R")
  geogr_units = unique(df[[geo_level]])
  
  label_df_list = list()
  for (location in geogr_units){
    
    # Step 1
    df_price_vector = df[which(df[[geo_level]] == location), ]
    price_vector = df_price_vector[[commodity_type]]
    
    derivative_vector <- get_derivative(price_vector)
    # Step 2
    source("src/aggregate_quantity.R")
    aggr_stats <- aggregate_quantity(derivative_vector)
    sd_der = aggr_stats$sd
    mean_der = aggr_stats$mean
    n_missing_der = aggr_stats$n_missing
    frac_missing_der = aggr_stats$frac_missing
    n_der = aggr_stats$n
    
    new_df = data.frame(location = location, sd_der = sd_der, mean_der = mean_der, 
                        n_missing_der = n_missing_der, frac_missing_der = frac_missing_der,
                        n_der = n_der)
    names(new_df)[1] = geo_level
    # return a vector with the standard deviation, the mean and the number of missing price points
    
    # Step 3
    # source("src/assign_label.R")
    # new_df$label <- assign_label(new_df, thres=NULL, frac_missing = frac_missing)
    # return label
    label_df_list[[location]] = new_df
  }
  label_df = do.call(rbind, label_df_list)
  
  # return a data frame with labels or trend characteristics
  return(label_df)
}
  
  