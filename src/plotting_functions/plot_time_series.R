library(ggplot2)

data_subdistrict = data_long %>%
  group_by(q_sbd, item) %>%
  summarize(price = mean(price))

gg_per_town_per_item = 
  ggplot(data_long, aes(x = month, y = price, group = q_town))+
  geom_line(color = 'grey')+
  geom_line(data = data_subdistrict, aes(x = month, y = price), color = 'red', linewidth = 2)+
  facet_wrap(~q_sbd)+
  theme_bw()
  