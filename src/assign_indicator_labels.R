#Indicators - rows 2 through 5 are used to identify each label
indicators=data.frame(label=c("Stable positive trend", "Stable negative trend", "Stable",
                              "Volatile constant", "Volatile Positive Trend",
                              "Volatile Negative Trend", "Increasing","Decreasing"),
                      mean_in_range=c(FALSE, FALSE, TRUE, NA, NA, NA, FALSE, FALSE),
                      stddev_in_range=c(TRUE, TRUE, TRUE, NA, FALSE, FALSE, NA, NA), 
                      #^I think the fourth one for stddev should be FALSE, not NA - my code may have worked by luck of order of check
                      signs=c(2, -2, NA, 0, 2, -2, 1, -1),
                      zero_val=c(FALSE, FALSE, NA, FALSE, FALSE, FALSE, TRUE, TRUE))

setwd("C:/Users/Andrei/OneDrive/ETH Zurich/IMPACT Initiatives/csv output")

data <- read.csv(file="data_wder.csv", header=TRUE, sep=",")
data$Month<-as.yearmon(data$Month, "%b %Y")

subdistricts<-unique(data$q_sbd)
months<-unique(data$Month)
months<-sort(months)

#build table with all months and all subdistrict
#(even if that subdistrict does not have data for that month)
full_TS <- data.frame(subdistrict=character(),
                      month=as.yearmon(double()),
                      val=double(),
                      label=character(),
                      realization=character(),
                      correct=logical()) 
for (sbd in subdistricts){
  for (month in months){
    val<-data[data$q_sbd==sbd & data$Month==month,"der_smeb_incomplete"]
    if (length(val)==0){ #if no data for that sbd for that month
      temp<-data.frame(subdistrict=sbd, month=month, val=NA, label=NA, realization=NA, correct=NA)
    } else { #if there is data
      temp<-data.frame(subdistrict=sbd, month=month, val=val, label=NA, realization=NA, correct=NA)
    }
    full_TS<-rbind(full_TS, temp)
  }
}
full_TS$month<-as.yearmon(full_TS$month)
full_TS$val<-as.numeric(full_TS$val)


#Assign labels
#note that this is currently not general at all
#it only works for a window of three months (two derivatives) and
#obviously the inputs (i.e. stable mean range, stable volatility)
#are all hardcoded
for (i in 2:nrow(full_TS)){
  if (full_TS[i,"month"]!=min(months)){ #if it is not the first month of the dataset (derivative not possible if it is)
    mean_val<-mean(c(full_TS[i-1,"val"], full_TS[i,"val"]))
    stddev<-sd(c(full_TS[i-1,"val"], full_TS[i,"val"]))
    sign1<-sign(full_TS[i-1,"val"])
    sign2<-sign(full_TS[i,"val"])
    
    #set values which will be compared to 'indicators' df (in order to assign the label)
    if (!is.na(mean_val)){
      mean_in_range <- mean_val >= -2000 && mean_val<=2000
      stddev_in_range <- stddev >= 0 && stddev <= 6000
      signs<-sign1+sign2
      zero_val<-sign1==0
    } else {
      #any value that does not satisfy upcoming check
      mean_in_range=2019
      stddev_in_range=2019
      signs=2019
      zero_val=2019
    }
    
    #Compare to 'indicators' df and assign label accordingly
    if (!is.na(sign2) && sign2==0){ #if latest derivative=0 then assign label as "Stable"
      full_TS[i,"label"]=="Stable"
    } else { #otherwise check using df
      compare=c(mean_in_range, stddev_in_range, signs, zero_val)
      
      #go through each label one by one and check if conditions are satisfied
      for (check in 1:nrow(indicators)){
        equal<-compare==indicators[check,c("mean_in_range", "stddev_in_range", "signs", "zero_val")]
        equal[is.na(equal)] <- TRUE
        
        #if they are satisfied then assign that label
        if (all(equal)){
          full_TS[i,"label"]<-as.character(indicators[check,"label"])
        }
      }
    }
  }
}

#For anyone that is not Andrei ignore this, this is some testing I did but it is not right
for (i in 2:nrow(full_TS)){
  if (full_TS[i,"month"]!=months[1] && !is.na(full_TS[i+1,"val"]) && !is.na(full_TS[i,"val"]) && !is.na(full_TS[i-1,"val"])){
    if (full_TS[i+1,"val"]>=2000 && full_TS[i+1,"val"]<=6000){
      full_TS[i,"realization"]="Stable positive trend"
    } else if (full_TS[i+1,"val"]<=-2000 && full_TS[i+1,"val"]>=-6000){
      full_TS[i,"realization"]="Stable negative trend"
    } else if (full_TS[i+1,"val"]>=-2000 && full_TS[i+1,"val"]<=2000){
      full_TS[i,"realization"]="Stable"
    } else if (full_TS[i+1,"val"]>6000){
      full_TS[i,"realization"]="Volatile Positive Trend"
    } else if (full_TS[i+1,"val"]<-6000){
      full_TS[i,"realization"]="Volatile Negative Trend"
    } else if (full_TS[i+1,"val"]>0){
      full_TS[i,"realization"]="Increasing"
    } else if (full_TS[i+1,"val"]<0){
      full_TS[i,"realization"]="Decreasing"
    }
  }
}

#write.csv(full_TS,'smeb_model.csv')
