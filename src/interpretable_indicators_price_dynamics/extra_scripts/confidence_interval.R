confidence_interval <- function(df, 
                                final_month, 
                                time_window = 6,
                                conf_interval = .95,
                                price_col = 'SMEB', 
                                geogr_level = 'q_district',
                                geogr_columns = c('region','q_distr','q_sbd')){
  df = df %>%
    filter(Month == month) %>%
    select(one_of(c(price_col, geogr_columns)))
  df = aggregate_geogr_level(df, price_col, geogr_level, geogr_columns)
  derivative = get_derivative(df[[price_col]])
  aggregated_stats = aggregate_quantity(derivative)
  n = aggregated_stats$n
  n_missing = aggregated_stats$n_missing+1
  sd_price = aggregated_stats$sd
  mean_price = aggregated_stats$mean
  thres = 1- (1-conf_interval)/2
  n_complete = n - n_missing
  q_sigma = qnorm(thres)*sd/sqrt(n_complete)
  mean_price = mean(df[[price_col]], na.rm = T)
  max_price = mean_price + q_sigma
  min_price = mean_price - q_sigma
  return(list(min_price = min_price,
              max_price = max_price))
}