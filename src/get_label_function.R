#' Assign a label (stable, trend, volatile or volatile trend) to a commodity type 
#' for a specific region based on the price developement over the past months
#' 
#' @return a label which classifies the price of a commoditiy as stable, trend, volatile or volatile trend
#' @inheritParams indicators
get_label<- function(df, time_window=6, final_month, frac_missing=0.2, 
                     geo_level, commodity_type){
  
  # Step 0
  source("aggregate_price_geogr.R")
  price_vector <- aggregate_price_geogr(df,geo_level, commodity_type)
    df= median(df) # groupby geo_level and take median over prices
    if(commoditiy_type=='SMEB') {
      df=calc_SMEB_geogr(geogr,df)
    }
    
  # take df and output df_aggr and complete it
  # return a price vector
  
  # Step 1
  source("get_derivative.R")
  derivative_vector <- get_derivative(price_vector)
  # return a derivatie vector
  
  # Step 2
  source("aggregate_quantity.R")
  c(SD,mean,numb_missing_prices) <- aggregate_quantity(price_vector, derivative_vector)
  # return a vector with the standard deviation, the mean and the number of missing price points
  
  # Step 3
  source("give_label")
  label <- give_label()
  # return label
  
  return(label)
}
  
  