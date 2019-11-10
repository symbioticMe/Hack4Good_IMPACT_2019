# INPUTS: 
# price vector of length of the specified time window,
# already filtered at the geographical level to be analyzed

# OUTPUT:
# vector of same length as the input but with derivatives

get_derivative<-function(price_vector){
  
  derivative_vector <- matrix(NA, nrow=length(price_vector), ncol=1)
  
  price_vector_mod <- price_vector[!is.na(price_vector)]
  
  for (i in 1:length(price_vector_mod)){
    derivative_vector[i]=price_vector[i+1]-price_vector[i]
  }
  
  return(derivative_vector)
}