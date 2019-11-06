aggregate_quantity <- function(price_vector){
  price_sd = sd(price_vector, na.rm = T)
  price_mean = mean(price_vector, na.rm = T)
  n = length(price_vector)
  n_missing = sum(is.na(price_vector))
  frac_missing = n_missing/n
  return(list(sd = price_sd,
              mean = price_mean,
              n_missing = n_missing,
              frac_missing = frac_missing,
              n = n))
}