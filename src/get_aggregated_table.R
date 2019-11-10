#INPUT: data frame which is the reading in
#1) aggregated_data.csv
#2) geographical level for prices to be aggregated at 
# (options are 'region', 'gov' 'distict', 'sbd', 'town')
# 3) commodity type - if it's SMEB, we add SMEB columns to data frame 
# (can't do this) if geo_level="region" though
# 4) time_window - integer for the number of months to be analyzed
# 5) final_month - the last month for the analysis (i.e., the analysis will be
# done on the 'time_window' months up to the 'final_month')

get_aggregated_table <- function(df, geo_level = 'q_district', commodity_type = 'smeb_total_float', time_window = 6, final_month){
  source("src/aggregate_price_geogr.R")
  df <- aggregate_price_geogr(df, geo_level, commodity_type)
  
  # take df and output df_aggr and complete it
  source('src/complete_data.R')
  df <- complete_data(df)
  
  #filter on time window
  source('src/filter_on_time_window.R')
  df <- filter_on_time_window(data = df, time_window = time_window, final_month = final_month)
  return(df)
}