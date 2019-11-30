assign_label <- function(new_df, thres_mean = NULL, thres_SD = NULL, frac_missing){
  if(!is.null(thres_mean) & !is.null(thres_SD)){
    if(thres_SD < 1 & thres_SD > 0){
      thres_SD = new_df$mean * thres_SD
    }
    if(SD > thres_SD){
      if (mean > thres_mean){
        label<-"trend_volatile"
      } else {
        label<-"volatile"
      }
    } else {
      if (mean > thres_mean){
        label<-"trend"
      } else {
        label<-"stable"
      }
    }
  } else {
    stop("can't assign labels as the thresholds are missing!")
  }
}