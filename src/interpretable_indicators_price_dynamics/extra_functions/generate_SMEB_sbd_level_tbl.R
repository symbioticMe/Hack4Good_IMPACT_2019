generate_SMEB_sbd_level_tbl <- function(){

#set working directory to the repository of "Interpretable Indicators" (team "wonderwoman")
setwd("C:/Users/Andrei/OneDrive/ETH Zurich/IMPACT Initiatives/code/wonderwoman")
#this is the main data file, created in 
read_in_df <- read.csv(file="data/aggregated_monthly_1.csv", header=TRUE, sep=",")

#Data aggregated at the specified geographical level (with prices grouped by median)
#contains smeb columns if input 'commodity_type' is a smeb value
source('src/interpretable_indicators_price_dynamics/aggregate_price_geogr.R')
df = aggregate_price_geogr(read_in_df, 'q_sbd', 'smeb')

write.csv(df, "data/processed/SMEB_sbd_level.csv")

}