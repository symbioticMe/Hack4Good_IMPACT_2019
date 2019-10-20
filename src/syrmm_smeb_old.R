smeb_calculations<-function(data){
  
  `%!in%` = Negate(`%in%`)
  
#SMEB contents lists (complete and sans water)
  smeb_items<-c("q_smeb_bread",
                "q_smeb_bulgur",
                "q_smeb_chicken",
                "q_smeb_eggs",
                "q_smeb_lentils",
                "q_smeb_rice",
                "q_smeb_salt",
                "q_smeb_sugar",
                "q_smeb_tomatop",
                "q_smeb_isoap",
                "q_smeb_spads",
                "q_smeb_toothp",
                "q_smeb_water",
                "q_smeb_gbdata",
                "smeb_food_veggie",
                "smeb_cooking_oils",
                "smeb_nfi_soaps",
                "smeb_cookingfuels")
  
  smeb_items_sans_water<-c("q_smeb_bread",
                           "q_smeb_bulgur",
                           "q_smeb_chicken",
                           "q_smeb_eggs",
                           "q_smeb_lentils",
                           "q_smeb_rice",
                           "q_smeb_salt",
                           "q_smeb_sugar",
                           "q_smeb_tomatop",
                           "q_smeb_isoap",
                           "q_smeb_spads",
                           "q_smeb_toothp",
                           "q_smeb_gbdata",
                           "smeb_food_veggie",
                           "smeb_cooking_oils",
                           "smeb_nfi_soaps",
                           "smeb_cookingfuels")
  
##Creates SMEB Values for all values that don't adjust based on other values
data %>% 
  mutate(
    ####Food###
    #Presume 8 pieces of bread ~ 1kg
    q_smeb_bread = 37*q_bread_price_per_8pieces,
    q_smeb_bulgur = 15*q_bulgur_price_per_kilo,
    q_smeb_chicken = 6*q_chicken_price_per_kilo,
    #Presume 30 eggs ~1kg
    q_smeb_eggs = 6*q_eggs_price_per_30eggs,
    q_smeb_lentils = 15*q_rlentils_price_per_kilo,
    q_smeb_rice = 19*q_rice_price_per_kilo,
    q_smeb_salt = 2*q_salt_price_per_500g,
    q_smeb_sugar = 5*q_sugar_price_per_kilo,
    q_smeb_tomatop = 6*q_tomatop_price_per_kilo,
    
    ###NFI###
    q_smeb_isoap = 12*q_isoap_price_per_piece,
    q_smeb_spads = 4*q_spads_price_per_10pads,
    q_smeb_toothp = 2*q_toothp_price_per_100g,
  
    ###Other###
    q_smeb_water = 4500*q_water_price_per_litre,
    q_smeb_gbdata = q_data_price_per_gb,
    q_smeb_xrate = q_xrate_usdsyp_sell
  ) -> data
    
#If oil and ghee exist, take 3.5 of each. If one is gone, take 7 of the other.
data %>%
  mutate(
    q_smeb_ghee = ifelse(is.na(q_oil_price_per_litre),
                       7*q_ghee_price_per_kilo,
                       3.5*q_ghee_price_per_kilo),
    
    q_smeb_oil = ifelse(is.na(q_ghee_price_per_kilo),
                         7*q_oil_price_per_litre,
                        3.5*q_oil_price_per_litre),
    
    q_smeb_lsoap = ifelse(is.na(q_dsoap_price_per_litre),
                        3*q_lsoap_price_per_kilo,
                        1.5*q_lsoap_price_per_kilo),
    
    q_smeb_dsoap = ifelse(is.na(q_lsoap_price_per_kilo),
                          3*q_dsoap_price_per_litre,
                          1.5*q_dsoap_price_per_litre),
    
    #Only calculated Kaz if not in southern syria, unless no SGAS.
    q_smeb_kaz = ifelse(q_gov %!in% c("SY01", "SY03", "SY12", "SY14"),
                        25*q_mrkaz_price,
                        ifelse(is.na(q_sgas_price),
                               25*q_mrkaz_price,
                               NA)),
    
    q_smeb_lpg = ifelse(q_gov %in% c("SY01", "SY03", "SY12", "SY14"),
                        25*(q_sgas_price),
                        ifelse(is.na(q_mrkaz_price),
                               25*(q_sgas_price),
                               NA)),
    
    q_smeb_tomatoes = ifelse(is.na(q_tomatoes_price_per_kilo),
                             #No tomatoes
                             NA,
                             #Tomatoes
                             ifelse(is.na(q_potatoes_price_per_kilo),
                                    #No potatoes
                                    ifelse(is.na(q_onions_price_per_kilo),
                                           #No onions
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No potatoes, onions, or cucumber.
                                                  12*q_tomatoes_price_per_kilo,
                                                  #No potatoes or onions.
                                                  6*q_tomatoes_price_per_kilo),
                                           #Onions
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No potatoes or cucumber.
                                                  6*q_tomatoes_price_per_kilo,
                                                  #No potatoes.
                                                  4*q_tomatoes_price_per_kilo)),
                                    #Potatoes
                                    ifelse(is.na(q_onions_price_per_kilo),
                                           #No onions
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No onions or cucumber.
                                                  6*q_tomatoes_price_per_kilo,
                                                  #No onions.
                                                  4*q_tomatoes_price_per_kilo),
                                           #Onions
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No cucumber.
                                                  4*q_tomatoes_price_per_kilo,
                                                  #All veggies available.
                                                  3*q_tomatoes_price_per_kilo)))),
    
    q_smeb_potatoes = ifelse(is.na(q_potatoes_price_per_kilo),
                             #No potatoes
                             NA,
                             #potatoes
                             ifelse(is.na(q_tomatoes_price_per_kilo),
                                    #No tomatoes
                                    ifelse(is.na(q_onions_price_per_kilo),
                                           #No onions
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No tomatoes, onions, or cucumber.
                                                  12*q_potatoes_price_per_kilo,
                                                  #No tomatoes or onions.
                                                  6*q_potatoes_price_per_kilo),
                                           #Onions
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No tomatoes or cucumber.
                                                  6*q_potatoes_price_per_kilo,
                                                  #No tomatoes.
                                                  4*q_potatoes_price_per_kilo)),
                                    #Tomatoes
                                    ifelse(is.na(q_onions_price_per_kilo),
                                           #No onions
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No onions or cucumber.
                                                  6*q_potatoes_price_per_kilo,
                                                  #No onions.
                                                  4*q_potatoes_price_per_kilo),
                                           #Onions
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No cucumber.
                                                  4*q_potatoes_price_per_kilo,
                                                  #All veggies available.
                                                  3*q_potatoes_price_per_kilo)))),
    
    q_smeb_onions = ifelse(is.na(q_onions_price_per_kilo),
                             #No onions
                             NA,
                             #onions
                             ifelse(is.na(q_tomatoes_price_per_kilo),
                                    #No tomatoes
                                    ifelse(is.na(q_potatoes_price_per_kilo),
                                           #No potatoes
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No tomatoes, potatoes, or cucumber.
                                                  12*q_onions_price_per_kilo,
                                                  #No tomatoes or potatoes.
                                                  6*q_onions_price_per_kilo),
                                           #potatoes
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No tomatoes or cucumber.
                                                  6*q_onions_price_per_kilo,
                                                  #No tomatoes.
                                                  4*q_onions_price_per_kilo)),
                                    #Tomatoes
                                    ifelse(is.na(q_potatoes_price_per_kilo),
                                           #No potatoes
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No potatoes or cucumber.
                                                  6*q_onions_price_per_kilo,
                                                  #No potatoes.
                                                  4*q_onions_price_per_kilo),
                                           #potatoes
                                           ifelse(is.na(q_cucumbers_price_per_kilo),
                                                  #No cucumber.
                                                  4*q_onions_price_per_kilo,
                                                  #All veggies available.
                                                  3*q_onions_price_per_kilo)))),

    q_smeb_cucumbers = ifelse(is.na(q_cucumbers_price_per_kilo),
                           #No cucumbers
                           NA,
                           #cucumbers
                           ifelse(is.na(q_tomatoes_price_per_kilo),
                                  #No tomatoes
                                  ifelse(is.na(q_potatoes_price_per_kilo),
                                         #No potatoes
                                         ifelse(is.na(q_onions_price_per_kilo),
                                                #No tomatoes, potatoes, or onions.
                                                12*q_cucumbers_price_per_kilo,
                                                #No tomatoes or potatoes.
                                                6*q_cucumbers_price_per_kilo),
                                         #potatoes
                                         ifelse(is.na(q_onions_price_per_kilo),
                                                #No tomatoes or onions.
                                                6*q_cucumbers_price_per_kilo,
                                                #No tomatoes.
                                                4*q_cucumbers_price_per_kilo)),
                                  #Tomatoes
                                  ifelse(is.na(q_potatoes_price_per_kilo),
                                         #No potatoes
                                         ifelse(is.na(q_onions_price_per_kilo),
                                                #No potatoes or onions.
                                                6*q_cucumbers_price_per_kilo,
                                                #No potatoes.
                                                4*q_cucumbers_price_per_kilo),
                                         #potatoes
                                         ifelse(is.na(q_onions_price_per_kilo),
                                                #No onions.
                                                4*q_cucumbers_price_per_kilo,
                                                #All veggies available.
                                                3*q_cucumbers_price_per_kilo)))),
    
    nonstandard_cookingoil = ifelse(is.na(q_oil_price_per_litre),
                                      ifelse(is.na(q_ghee_price_per_kilo),
                                             "missing both",
                                             "no oil"),
                                      ifelse(is.na(q_ghee_price_per_kilo),
                                             "no ghee",
                                             NA)),
    
    nonstandard_soaps = ifelse(is.na(q_lsoap_price_per_kilo),
                                    ifelse(is.na(q_dsoap_price_per_litre),
                                           "missing both",
                                           "no lsoap (laundry)"),
                                    ifelse(is.na(q_dsoap_price_per_litre),
                                           "no dsoap (dish)",
                                           NA)),
    
    nonstandard_fuels = ifelse(q_gov %in% c("SY01", "SY03", "SY12", "SY14"),
                               ifelse(is.na(q_smeb_lpg),
                                      ifelse(is.na(q_smeb_kaz),
                                             "no cooking fuels",
                                             "no lpg in south, but kaz"),
                                      NA),
                               ifelse(is.na(q_smeb_kaz),
                                       ifelse(is.na(q_smeb_lpg),
                                              "no cooking fuels",
                                              "no kaz in north, but lpg"),
                                       NA)),
    
    nonstandard_veggies = ifelse(is.na(q_tomatoes_price_per_kilo),
                                 #No Tomatoes
                                ifelse(is.na(q_potatoes_price_per_kilo),
                                       #No Potatoes
                                       ifelse(is.na(q_onions_price_per_kilo),
                                              #No Onions
                                              ifelse(is.na(q_cucumbers_price_per_kilo),
                                                     "No veggies",
                                                     "No tomatoes, potatoes, onions"),
                                              #Onions
                                              ifelse(is.na(q_cucumbers_price_per_kilo),
                                                     "No tomatoes, potatoes, cucumbers",
                                                     "No tomatoes, potatoes")),
                                       #Potatoes
                                       ifelse(is.na(q_onions_price_per_kilo),
                                              #No Onions
                                              ifelse(is.na(q_cucumbers_price_per_kilo),
                                                     "No tomatoes, onions, cucumbers",
                                                     "No tomatoes, onions"),
                                              #Onions
                                              ifelse(is.na(q_cucumbers_price_per_kilo),
                                                     "No tomatoes, cucumbers",
                                                     "No tomatoes"))),
                                #Tomatoes
                                ifelse(is.na(q_potatoes_price_per_kilo),
                                       #No Potatoes
                                       ifelse(is.na(q_onions_price_per_kilo),
                                              #No Onions
                                              ifelse(is.na(q_cucumbers_price_per_kilo),
                                                     "No potatoes, onions, cucumbers",
                                                     "No potatoes, onions"),
                                              #Onions
                                              ifelse(is.na(q_cucumbers_price_per_kilo),
                                                     "No potatoes, cucumbers",
                                                     "No potatoes")),
                                       #Potatoes
                                       ifelse(is.na(q_onions_price_per_kilo),
                                              #No Onions
                                              ifelse(is.na(q_cucumbers_price_per_kilo),
                                                     "No onions, cucumbers",
                                                     "No onions"),
                                              #Onions
                                              ifelse(is.na(q_cucumbers_price_per_kilo),
                                                     "No cucumbers",
                                                     NA))))
    
  ) -> data

#############################################
#############################################
# 4. Create Categories and Sub-categories   #
#############################################
#############################################

#This creates variables for SMEB components (ex. food, nfi) 
data %>%
  mutate(smeb_food_veggie = rowSums(cbind(q_smeb_tomatoes,
                                          q_smeb_potatoes,
                                          q_smeb_onions,
                                          q_smeb_cucumbers),
                                    na.rm = T),
         
         smeb_cooking_oils = rowSums(cbind(q_smeb_ghee,
                                           q_smeb_oil),
                                     na.rm = T),
         smeb_nfi_soaps = rowSums(cbind(q_smeb_lsoap,
                                       q_smeb_dsoap),
                                 na.rm = T),
                                  
          smeb_food = rowSums(cbind(smeb_food_veggie,
                                  smeb_cooking_oils,
                                  q_smeb_salt,
                                  q_smeb_sugar,
                                  q_smeb_tomatop,
                                  q_smeb_bread,
                                  q_smeb_bulgur,
                                  q_smeb_rice,
                                  q_smeb_chicken,
                                  q_smeb_eggs,
                                  q_smeb_lentils),
                                   na.rm = F),
         
          smeb_nfi = rowSums(cbind(q_smeb_isoap,
                                  smeb_nfi_soaps,
                                  q_smeb_toothp,
                                  q_smeb_spads),
                            na.rm = F),
         
         smeb_cookingfuels = rowSums(cbind(q_smeb_kaz,
                                           q_smeb_lpg),
                                     na.rm = T)
         ) -> data

#Create average transport fuel price
  data$trans_fuel <- rowMeans(subset(data,select=c(q_rgpetrol_price,
                                            q_mrpetrol_price,
                                            q_rgdiesel_price,
                                            q_mrdiesel_price)),na.rm = T)
  
  

##Replace All SMEB composite categories with NA's if they are 0.
data$smeb_food[data$smeb_food == 0] <- NA
data$smeb_food_veggie[data$smeb_food_veggie == 0] <- NA
data$smeb_nfi[data$smeb_nfi == 0] <- NA
data$smeb_nfi_soaps[data$smeb_nfi_soaps == 0] <- NA
data$smeb_cooking_oils[data$smeb_cooking_oils == 0] <- NA
data$smeb_cookingfuels[data$smeb_cookingfuels == 0] <- NA
data$q_smeb_water[data$q_smeb_water == 0] <- NA
data$q_smeb_gbdata[data$q_smeb_gbdata == 0] <- NA

##Create new binary variable that says if smeb complete or not.
data %>%
  mutate(smeb_complete = !is.na(rowSums(data[,smeb_items],
                                        na.rm = F))) -> data

#############################################
#############################################
# 5. Calculation if only missing water      #
#############################################
#############################################

#Creates binary which is TRUE if missing water
data %>%
  mutate(missing_water = is.na(q_smeb_water)) -> data

#Creates binary which is TRUE if REST OF SMEB is COMPLETE
data %>%
  mutate(smeb_complete_sans_water = !is.na(rowSums(data[,smeb_items_sans_water],
                                        na.rm = F))) -> data

#Create Variable which is TRUE only when ONLY SMEB MISSING IS WATER
data$smeb_only_missing_water <- "FALSE"
data$smeb_only_missing_water[data$missing_water == TRUE & data$smeb_complete_sans_water == TRUE] <- TRUE

#Remove Extra columns
data$missing_water <- NULL
data$smeb_complete_sans_water <- NULL

#############################################
#############################################
# 7. Calculation of total SMEB Cost         #
#############################################
#############################################

data %>%
  mutate(smeb_total_float = 1.075*(rowSums(data[,smeb_items],
                              na.rm = F)),
          
         smeb_sanswater_float = 1.075*(rowSums(data[,smeb_items_sans_water],
                              na.rm = F)),
         smeb_incomplete = rowSums(data[,smeb_items],
                              na.rm = T),
       smeb_usd = smeb_total_float/q_xrate_usdsyp_sell
) -> data

return(data)
}
