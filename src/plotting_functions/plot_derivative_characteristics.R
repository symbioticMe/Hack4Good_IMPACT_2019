library(ggplot2)

geo_level = 'q_district'

plot_fluctuation_characteristics <- function(label_df_test, geo_level){
  if (length(unique(label_df_test[[geo_level]])) > 49){
    warning('subset fewer geographical areas to see the patterns!')
  }
  label_df_test = label_df_test %>%
    mutate(rel_mean = mean_der/mean_price,
           CV_der = sd_der/mean_price,
           frac_complete = 1- frac_missing_der)
  gg = ggplot(label_df_test, 
              aes_string(x = 'rel_mean', 
                         y = 'CV_der',
                        # size = 'frac_complete', 
                         label = geo_level))+
    geom_point(size = .1, alpha = .5)+
    geom_vline(xintercept = 0, linetype="dashed", size=0.2)+
    geom_text(size=3)+
    scale_y_log10()+
    theme_bw()+
    ylab('CV of derivative (SD / mean price)')+
    xlab('mean of derivative / mean price')
  return(gg)
}


