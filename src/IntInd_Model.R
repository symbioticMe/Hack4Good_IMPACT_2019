#Main script to run the Interpretable Indicators model


# User Input --------------------------------------------------------------

#Enter the geographical level for the indicators to be developed at
#Options are "region", "q_gov", "q_district", "q_sbd", "q_town"
geo_level='q_sbd'

#Enter the commodity to be analyzed
#Options are any of the columns that are outputted from IMPACT's SMEB calculation function
#i.e., smeb_total_float, q_bread_price_per_8pieces, etc.
commodity_type='smeb_total_float'

#The last month for which data is to be analyzed
final_month="Aug 19"

#The time window (in months) for the trends to be analyzed at
#An integer 
time_window=6

#currently not being used
#frac_missing


# Model -------------------------------------------------------------------

setwd("C:/Users/Andrei/OneDrive/ETH Zurich/IMPACT Initiatives/code/wonderwoman")
read_in_df <- read.csv(file="data/aggregated_monthly_1.csv", header=TRUE, sep=",")

#Data aggregated at the specified geographical level (with prices grouped by median)
#contains smeb columns if input 'commodity_type' is a smeb value
source('src/get_aggregated_table.R')
df = get_aggregated_table(read_in_df, geo_level = geo_level, commodity_type = commodity_type,
                          final_month = final_month, time_window = time_window)

#Table of summary statistics
source('src/get_label_function.R')
label_df = get_label(df, frac_missing = frac_missing, 
                     geo_level = geo_level, commodity_type = commodity_type)


library(ggpubr)
source("src/plotting_functions/plot_trends.R")
gg_trend = plot_trend(df, geo_level = geo_level, commodity_type = commodity_type)
source("src/plotting_functions/plot_derivative_characteristics.R")
gg_der = plot_fluctuation_characteristics(label_df, geo_level = geo_level)
if (length(unique(df[[geo_level]])) > 49){
  plot(gg_trend)
  plot(gg_der)
} else {
  options(repr.plot.width = 18, repr.plot.height = 10)
  ggarrange(gg_trend, gg_der, ncol = 2, labels = c('A', 'B'))
}
