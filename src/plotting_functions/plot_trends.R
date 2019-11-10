library(ggplot2)


plot_trend <- function(df, geo_level = 'q_district', 
                       commodity_type = 'smeb_total_float'){
  if (length(unique(df[[geo_level]])) > 49){
    warning('subset fewer geographical areas to see the patterns!')
  }
  gg_trend = ggplot(df, 
                    aes_string(x = Month,
                               y = commodity_type))+
    geom_point()+
    geom_line()+
    facet_wrap(~as.formula(paste("~", geo_level)))
  return(gg_trend)
}
