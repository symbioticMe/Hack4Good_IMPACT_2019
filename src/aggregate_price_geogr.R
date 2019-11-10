# INPUTS: 
# 1) aggregated_data.csv (output from our first code)
# 2) geographical level for prices to be aggregated at 
# (options are 'region', 'gov' 'distict', 'sbd', 'town')
# 3) commodity type - if it's SMEB, we add SMEB columns to data frame 
# (can't do this) if geo_level="region" though

# OUTPUT:
# data with prices grouped plus SMEB for each row 
# (i.e. each month for each geo_level label)

#Need the following libraries:
library("DescTools")
library(tidyverse)

aggregate_price_geogr<-function(data, geo_level, commodity_type){
  
  #geo_level_possibilities <- c("region", "gov", "district", "sbd", "town")
  col_name_in_data <- c("region", "q_gov", "q_district", "q_sbd", "q_town")
  level<-grep(geo_level, col_name_in_data)
  
  #Prices will be grouped at the level specified by the input 'geo_level'
  #as well the month and all higher level geographical levels
  cols_group<-c("Month", col_name_in_data[1:level])
  
  #group at the geographical level specified by the input and take the median, removing NAs
  agg_by_geo_level <- data %>%
    group_by_at(c(cols_group)) %>%
    summarize(q_bread_price_per_8pieces = median(as.numeric(q_bread_price_per_8pieces), na.rm = TRUE),
              q_bulgur_price_per_kilo=median(as.numeric(q_bulgur_price_per_kilo), na.rm=TRUE),
              q_chicken_price_per_kilo=median(as.numeric(q_chicken_price_per_kilo), na.rm=TRUE),
              q_eggs_price_per_30eggs=median(as.numeric(q_eggs_price_per_30eggs), na.rm=TRUE),
              q_potatoes_price_per_kilo=median(as.numeric(q_potatoes_price_per_kilo), na.rm=TRUE),
              q_tomatoes_price_per_kilo=median(as.numeric(q_tomatoes_price_per_kilo), na.rm=TRUE),
              q_ghee_price_per_kilo=median(as.numeric(q_ghee_price_per_kilo), na.rm=TRUE),
              q_oil_price_per_litre=median(as.numeric(q_oil_price_per_litre), na.rm=TRUE),
              q_rlentils_price_per_kilo=median(as.numeric(q_rlentils_price_per_kilo), na.rm=TRUE),
              q_rice_price_per_kilo=median(as.numeric(q_rice_price_per_kilo), na.rm=TRUE),
              q_salt_price_per_500g=median(as.numeric(q_salt_price_per_500g), na.rm=TRUE),
              q_sugar_price_per_kilo=median(as.numeric(q_sugar_price_per_kilo), na.rm=TRUE),
              q_isoap_price_per_piece=median(as.numeric(q_isoap_price_per_piece), na.rm=TRUE),
              q_lsoap_price_per_kilo=median(as.numeric(q_lsoap_price_per_kilo), na.rm=TRUE),
              q_dsoap_price_per_litre=median(as.numeric(q_dsoap_price_per_litre), na.rm=TRUE),
              q_spads_price_per_10pads=median(as.numeric(q_spads_price_per_10pads), na.rm=TRUE),
              q_toothp_price_per_100g=median(as.numeric(q_toothp_price_per_100g), na.rm=TRUE),
              q_sgas_price=median(as.numeric(q_sgas_price), na.rm=TRUE),
              q_mrkaz_price=median(as.numeric(q_mrkaz_price), na.rm=TRUE),
              q_water_price_per_litre=median(as.numeric(q_water_price_per_litre), na.rm=TRUE),
              q_data_price_per_gb=median(as.numeric(q_data_price_per_gb), na.rm=TRUE),
              q_xrate_usdsyp_sell=median(as.numeric(q_xrate_usdsyp_sell), na.rm=TRUE),
              q_tomatop_price_per_kilo=median(as.numeric(q_tomatop_price_per_kilo), na.rm=TRUE),
              q_onions_price_per_kilo=median(as.numeric(q_onions_price_per_kilo), na.rm=TRUE),
              q_cucumbers_price_per_kilo=median(as.numeric(q_cucumbers_price_per_kilo), na.rm=TRUE),
              q_rgpetrol_price=median(as.numeric(q_rgpetrol_price), na.rm=TRUE),
              q_mrpetrol_price=median(as.numeric(q_mrpetrol_price), na.rm=TRUE),
              q_rgdiesel_price=median(as.numeric(q_rgdiesel_price), na.rm=TRUE),
              q_mrdiesel_price=median(as.numeric(q_mrdiesel_price), na.rm=TRUE)) %>%
    filter(!is.na(col_name_in_data[level]))
  
  if (commodity_type %like% "%smeb%"){
    source("src/syrmm_smeb_old.R")
    #pass in each row into IMPACT's function for calculating SMEB
    for (i in 1:nrow(agg_by_geo_level)){
      if (i==1){
        agg_price_w_smeb <- smeb_calculations(agg_by_geo_level[i,])
      } else{
        agg_price_w_smeb <- rbind(agg_price_w_smeb, smeb_calculations(agg_by_geo_level[i,]))
      }
    }
    return(agg_price_w_smeb)
    
  } else {
    #if not analyzing a SMEB value (i.e. we are interested in a specific 
    #commodity price) then return dataframe without adding SMEB columns
    
    return(agg_by_geo_level)
  }
}
