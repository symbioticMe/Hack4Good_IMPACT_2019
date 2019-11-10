library(ggplot2)

geo_level = 'q_district'

plot_fluctuation_characteristics <- function(label_df_test, geo_level){
  if (length(unique(label_df_test[[geo_level]])) > 49){
    warning('subset fewer geographical areas to see the patterns!')
  }
  label_df_test = label_df_test %>%
    mutate(rel_mean = mean_der/mean_price,
           CV_der = sd_der/abs(mean_der))
  gg = ggplot(label_df_test, 
              aes_string(x = 'rel_mean', 
                         y = 'CV_der', 
                         label = geo_level,
                         size = -'frac_missing_der'))+
    geom_point()+
    geom_vline(xintercept = 0, linetype="dashed", size=0.2)+
    scale_y_log10()+
    theme_bw()
  return(gg)
}


