library(reshape2)
library(tidyverse)

#load the data
df_joined_months = read_csv('aggregated_monthly_df.csv')

regional_columns = c("region", "q_gov", "q_district", "q_sbd", "q_town")
df_long = df_joined_months %>%
  melt(id.vars = regional_columns, variable.name = 'item', value.name = 'price') %>%
  mutate(item = gsub('q_([a-z]+)_pric(.)*','\\1', item))

write_csv(df_long, 'joint_monthly_df_long.csv')