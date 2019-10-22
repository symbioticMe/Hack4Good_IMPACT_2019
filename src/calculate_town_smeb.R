calculate_town_smeb<-function(aggregated_data){
  
  #group at the subdistrict level and take the median, removing NAs
  median_by_town <- aggregated_data %>%
    group_by(Month, region, q_gov, q_district, q_sbd, q_town) %>%
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
    filter(!is.na(q_town))
  
  #pass in each row into IMPACT's function for calculating SMEB
  for (i in 1:nrow(median_by_town)){
    if (i==1){
      sbd_smeb <- smeb_calculations(median_by_town[i,])
    } else{
      sbd_smeb <- rbind(sbd_smeb, smeb_calculations(median_by_town[i,]))
    }
  }
  
  return(sbd_smeb)
}