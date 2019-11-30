#INPUTS:
#1) aggregated_data.csv
#2) geographical level for prices to be aggregated at 
# (options are 'region', 'gov' 'distict', 'sbd', 'town')
# 3) commodity type - if it's SMEB, we add SMEB columns to data frame 
# (can't do this) if geo_level="region" though
# 4) time_window - integer for the number of months to be analyzed
# 5) final_month - the last month for the analysis (i.e., the analysis will be
# done on the 'time_window' months up to the 'final_month')

#OUTPUT:
#1) A table with data only for the months of the time window to be analyzed, with
#data grouped at the geographical level specified by the user (taking median of prices)

get_aggregated_table <- function(df, geo_level = 'q_district', commodity_type = 'smeb_total_float', time_window = 6, final_month){
  source("src/main_workflow_price_dynamics/interim_functions/aggregate_price_geogr.R")
  df <- aggregate_price_geogr(df, geo_level, commodity_type)
  
  # take df and output df_aggr and complete it
  source('src/main_workflow_price_dynamics/interim_functions/complete_data.R')
  df <- complete_data(df)
  
  #filter on time window
  source('src/main_workflow_price_dynamics/interim_functions/filter_on_time_window.R')
  df <- filter_on_time_window(data = df, time_window = time_window, final_month = final_month)
  return(df)
}