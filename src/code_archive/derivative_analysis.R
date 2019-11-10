
# Section 1 - Add Caclulated Columns to Data ------------------------------------------------

library(zoo)
library(lubridate)
setwd("C:/Users/Andrei/OneDrive/ETH Zurich/IMPACT Initiatives/csv output")

data <- read.csv(file="SMEB_sbd_level 2019-10-29 .csv", header=TRUE, sep=",")

#I forget why I did this, I will look in to it on Wednesday
data<-data[!(data$Month=="" | data$region=="" | data$q_gov=="" | data$q_district==""), ]

data$Month=as.yearmon(data$Month, "%b %y")

#to be used to loop through SBDs and do calculations later
subdistricts<-unique(data$q_sbd)

#variables for which we will calculate a derivative column
derivatives<-c('smeb_total_float',
               'smeb_sanswater_float',
               'smeb_incomplete',
               'q_bread_price_per_8pieces',
               'q_bulgur_price_per_kilo',
               'q_chicken_price_per_kilo',
               'q_eggs_price_per_30eggs',
               'q_potatoes_price_per_kilo',
               'q_tomatoes_price_per_kilo',
               'q_ghee_price_per_kilo',
               'q_oil_price_per_litre',
               'q_rlentils_price_per_kilo',
               'q_rice_price_per_kilo',
               'q_salt_price_per_500g',
               'q_sugar_price_per_kilo',
               'q_isoap_price_per_piece',
               'q_lsoap_price_per_kilo',
               'q_dsoap_price_per_litre',
               'q_spads_price_per_10pads',
               'q_toothp_price_per_100g',
               'q_sgas_price',
               'q_mrkaz_price',
               'q_water_price_per_litre',
               'q_data_price_per_gb',
               'q_xrate_usdsyp_sell',
               'q_tomatop_price_per_kilo',
               'q_onions_price_per_kilo',
               'q_cucumbers_price_per_kilo',
               'q_rgpetrol_price',
               'q_mrpetrol_price',
               'q_rgdiesel_price',
               'q_mrdiesel_price')

#matrix to write to - will be same as 'data' with derivative columns added
data_wder<-matrix(NA, nrow = 0, ncol = ncol(data)+length(derivatives))


#calculate all derivative columns for each sbd
for (sbd in subdistricts){
  temp<-data[data$q_sbd==sbd,]
  temp=temp[order(temp$Month),]
  
  #table with derivatives for current subdistrict
  der_data<-matrix(NA, nrow = nrow(temp), ncol = length(derivatives))
  
  
  for (i in 1:nrow(temp)){ #for each month with data
    for (d in derivatives){ #for each derivative to be calculated
      index<-grep(d,colnames(temp))
      val1<-temp[temp$Month==temp$Month[i],index]
      val2<-temp[temp$Month==(temp$Month[i]-(1/12)),index]
      if (length(val1)==0){val1<-NA} #if no value in the current month
      if (length(val2)==0){val2<-NA} #if no value in the last month
      der_data[i,grep(d,derivatives)]=val1-val2
    } 
  }
  colnames(der_data) <- paste("der_",derivatives, sep="")
  final<-cbind(temp,der_data) #add columns to existing data
  colnames(data_wder)<-colnames(final)
  data_wder<-rbind(data_wder,final) #add data + derivative columns to destination table
}

#write.csv(data_wder,'data_wder.csv')

# Section 2 - Plotting ----------------------------------------------------
setwd("C:/Users/Andrei/OneDrive/ETH Zurich/IMPACT Initiatives/plots")
  
for (var in derivatives){
  pdf(paste(var,".pdf",sep=""))
  for (sbd in subdistricts){
    plot_data<-data_wder[data_wder$q_sbd==sbd,]
    index<-grep(paste("der_",var, sep=""),colnames(plot_data))[1]
    
    if (!all(is.na(plot_data[,index]))){
      plot(plot_data$Month, plot_data[,index],ylab=var, xlab=NA, main=sbd)
      
      avg=round(mean(plot_data[,index], na.rm=TRUE), digits=2)
      std_dev<-round(sd(plot_data[,index], na.rm=TRUE), digits=2)
      mtext(paste("mean: ", avg, "; std dev: ", std_dev, sep=""), side = 1, line=-2, outer=TRUE)
    }
  }
  dev.off()
}

# Section Three - Analysis Set up ------------------------------------------------

#SMEBs I wanted to compare (plus I was curious about the xrate)
SMEBs <- c('der_smeb_total_float',
           'der_smeb_sanswater_float',
           'der_smeb_incomplete',
           'der_q_xrate_usdsyp_sell')

#create a table with one entry per subdistrict, with the total mean
#and total standard deviation (i.e., for all observations)
SMEB_HL_stats<-matrix(NA, nrow = 0, ncol = 1 + 3*length(SMEBs))
for (sbd in subdistricts){
  temp_matrix<-c(sbd)
  
  for (type in SMEBs){ #for each value to be calculated
    temp_data<-data_wder[data_wder$q_sbd==sbd, grep(type,colnames(data_wder))]
    count<-sum(!is.na(temp_data))
    mean<-round(mean(temp_data, na.rm=TRUE), digits=2)
    std_dev<-round(sd(temp_data, na.rm=TRUE), digits=2)
    
    temp_matrix<-cbind(temp_matrix, count, mean, std_dev)
  }
  
  SMEB_HL_stats<-rbind(SMEB_HL_stats, temp_matrix)
}
colnames(SMEB_HL_stats)<-c("subdistrict",
                           "count_total_float",
                           "mean_total_float",
                           "stddev_total_float",
                           "count_sanswater",
                           "mean_sanswater",
                           "stddev_sanswater",
                           "count_incomplete",
                           "mean_incomplete",
                           "stddev_incomplete",
                           "count_xrate",
                           "mean_xrate",
                           "stddev_xrate")

#write.csv(SMEB_HL_stats,'SMEB_HL_stats.csv')

SMEB_HL_stats<-as.data.frame(SMEB_HL_stats)


# Section Four - Charts ---------------------------------------------------

par(mfrow=c(2,2))
hist(as.numeric(levels(SMEB_HL_stats$count_total_float))[SMEB_HL_stats$count_total_float])
hist(as.numeric(levels(SMEB_HL_stats$count_sanswater))[SMEB_HL_stats$count_sanswater])
hist(as.numeric(levels(SMEB_HL_stats$count_incomplete))[SMEB_HL_stats$count_incomplete])
hist(as.numeric(levels(SMEB_HL_stats$count_xrate))[SMEB_HL_stats$count_xrate])

par(mfrow=c(2,2))
plot(ecdf(as.numeric(levels(SMEB_HL_stats$count_total_float))[SMEB_HL_stats$count_total_float]))
plot(ecdf(as.numeric(levels(SMEB_HL_stats$count_sanswater))[SMEB_HL_stats$count_sanswater]))
plot(ecdf(as.numeric(levels(SMEB_HL_stats$count_incomplete))[SMEB_HL_stats$count_incomplete]))
plot(ecdf(as.numeric(levels(SMEB_HL_stats$count_xrate))[SMEB_HL_stats$count_xrate]))

print(nrow(SMEB_HL_stats[as.numeric(levels(SMEB_HL_stats$count_total_float))[SMEB_HL_stats$count_total_float]>=10,])) #26
print(nrow(SMEB_HL_stats[as.numeric(levels(SMEB_HL_stats$count_sanswater))[SMEB_HL_stats$count_sanswater]>=10,])) #35
print(nrow(SMEB_HL_stats[as.numeric(levels(SMEB_HL_stats$count_incomplete))[SMEB_HL_stats$count_incomplete]>=10,])) #36
print(nrow(SMEB_HL_stats[as.numeric(levels(SMEB_HL_stats$count_xrate))[SMEB_HL_stats$count_xrate]>=10,])) #35

#look at subdistricts with at least 10 months with a valid derivative (to look at more complete data)
valid_sbd_for_analysis<-SMEB_HL_stats[as.numeric(levels(SMEB_HL_stats$count_incomplete))[SMEB_HL_stats$count_incomplete]>=10,"subdistrict"]
data_to_analyze<-data_wder[data_wder$q_sbd %in% valid_sbd_for_analysis,]

#Want to understand whether tolerances can be consistent for all subdistricts, or 
#whether each should have its own
smeb_means<-as.numeric(levels(SMEB_HL_stats[SMEB_HL_stats$subdistrict %in% valid_sbd_for_analysis,"mean_incomplete"]))
smeb_stddev<-as.numeric(levels(SMEB_HL_stats[SMEB_HL_stats$subdistrict %in% valid_sbd_for_analysis,"stddev_incomplete"]))
par(mfrow=c(1,2))
hist(smeb_means)
hist(smeb_stddev)
lh <- quantile(smeb_means,probs=0.025, na.rm=TRUE)	
uh <- quantile(smeb_means,probs=0.975, na.rm=TRUE)
smeb_means_removed <- smeb_means[smeb_means>lh & smeb_means<uh]
hist(smeb_means_removed)

lh <- quantile(smeb_stddev,probs=0.025, na.rm=TRUE)	
uh <- quantile(smeb_stddev,probs=0.975, na.rm=TRUE)
smeb_stddev_removed <- smeb_stddev[smeb_stddev>lh & smeb_stddev<uh]
hist(smeb_stddev_removed)

smeb_mean_around_zero <- smeb_means[smeb_means>=-5000 & smeb_means<=5000]
hist(smeb_mean_around_zero)
smeb_stddev_low <- smeb_stddev[smeb_stddev<=10000]
hist(smeb_stddev_low)

#since most of the mass is concentrated in the same place, i propose defining
#the thresholds at the same levels for all subdistricts

par(mfrow=c(1,1))
hist(data_wder$der_smeb_incomplete)
temp<-data_wder[abs(data_wder$der_smeb_incomplete)<=500000,"der_smeb_incomplete"]
hist(temp)
temp<-data_wder[abs(data_wder$der_smeb_incomplete)<=50000,"der_smeb_incomplete"]
hist(temp)
temp<-data_wder[abs(data_wder$der_smeb_incomplete)<=10000,"der_smeb_incomplete"]
hist(temp)
temp<-data_wder[abs(data_wder$der_smeb_incomplete)<=8000,"der_smeb_incomplete"]
hist(temp)
