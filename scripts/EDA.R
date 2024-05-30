library(tidyverse)
library(ggplot2)

# Load data
load("data_extracted/all_articles.RData")

# Select necessary columns
selected_articles <- all_articles %>%
  select(uuid, worries, title, published_at, url) %>% 
  mutate(date = as.Date(published_at)) #published_at to date

# Combine immigration and refugees into immig_refugee category
selected_articles <- selected_articles %>%
  mutate(worries = case_when(
    worries %in% c("immigration", "refugees") ~ "immig_refugee",
    TRUE ~ worries
  ))

# Calculate counts for each worry
count_data <- selected_articles %>%
  group_by(worries) %>%
  summarise(count = n()) %>%
  arrange(count)

#SALIENCE_OF_TOPICS_IN_MEDIA ----
# Reorder worries factor by count
selected_articles <- selected_articles %>%
  mutate(worries = factor(worries, levels = count_data$worries))

# Bar chart for article count by worry category
ggplot(selected_articles, aes(y = worries, fill = worries)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Article Count by Worry Category", x = "Count", y = "Worry Category") 

#TREND_PLOT ----
aggregated_data <- selected_articles %>%
  group_by(date, worries) %>%
  summarise(count = n()) %>%
  ungroup()

# Line plot for trend of articles over time by worry category 
ggplot(aggregated_data, aes(x = date, y = count, color = worries)) +
  geom_line(size = 1) +
  theme_minimal() +
  labs(title = "Trend of Articles Over Time by Worry Category", x = "Date", y = "Count", color = "Worry Category") +
  facet_wrap(~worries, scales = "free_y") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  scale_x_date(expand = expansion(mult = c(0, 0.05)))

