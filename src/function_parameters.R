# Document function parameters

#' @param df The data that contains the prices of comodity_types for several months and various geographical levels (data.frame)
#' @param time_window Number of months on which calculation of labels are based (string)
#' @param final_month The previous month of the month for which we are calculatin labels (string)
#' @param frac_missing Percentage of how many missing price points are admissable (float)
#' @param geo_level Georgraphicla level (governate, district, subdistrict, town) at which we compute the labels (string)
#' @param commodity_type Type of commoditiy (can be SMEB) for which we calculate a label (string)
#' 
#' @name indicators