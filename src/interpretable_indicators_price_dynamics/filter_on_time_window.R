# INPUTS: 
# data - output of the function 'complete_data'
# time_window - an integer for the number of months to be analyzed
# final_month - last month to be analyzed (string format)

# OUTPUT:
# data only filtered to include the months desired for analysis

filter_on_time_window<-function(data, time_window, final_month){
  
  final_month <- as.yearmon(final_month, "%b %y")
  beginning_month <- final_month-((time_window-1)/12)
  filtered_data <- data[data$Month>=beginning_month & data$Month<= final_month,]
  
  return(filtered_data)
}