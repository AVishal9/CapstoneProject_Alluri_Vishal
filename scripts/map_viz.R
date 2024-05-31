library(tidyverse)
library(sf)
library(ggplot2)
library(rio)

election_data <- rio::import("data/election_data.csv")

# Filter for canton-level results (based on kanton_nummer and kanton_bezeichnung) 
canton_results <- election_data %>%
  filter(!is.na(kanton_nummer), flag_staerkste_partei == 1) %>%
  select(kanton_nummer, kanton_bezeichnung, partei_bezeichnung_en, stimmen_partei, partei_staerke) %>%
  slice(1:26) #select the first 26 rows: contains aggregate data

head(canton_results)

# Import canton shapefile
cantons_shp <- st_read("data/boundaries.shp/swissBOUNDARIES3D_1_5_TLM_KANTONSGEBIET.shp") %>%
  select(KANTONSNUM, NAME, geometry) %>%
  st_transform(crs = 4326) %>%  # Change encoding
  st_zm(drop = TRUE, what = "ZM") # Convert geometries to 2D (XY)

# Fix column types for join
canton_results$kanton_nummer <- as.integer(canton_results$kanton_nummer)
cantons_shp$KANTONSNUM <- as.integer(cantons_shp$KANTONSNUM)

# Join election data with shapefile using kanton_nummer
cantons_with_results <- left_join(cantons_shp, canton_results, by = c("KANTONSNUM" = "kanton_nummer")) %>%
  filter(!st_is_empty(geometry))


##STRONGEST PARTY BY CANTON----

# Calculate centroids for label placement
cantons_with_results <- cantons_with_results %>%
  mutate(centroid = st_centroid(geometry)) %>%
  st_as_sf() %>%
  mutate(x = st_coordinates(centroid)[,1],
         y = st_coordinates(centroid)[,2])

party_colors <- c("FDP" = "blue", "SP" = "red", "SVP" = "darkgreen", "Centre" = "orange")

plot1 <- ggplot(cantons_with_results) +
  geom_sf(aes(fill = partei_bezeichnung_en), color = "black", size = 0.8) +
  geom_text(aes(x = x, y = y, label = paste(NAME, round(partei_staerke, 1), "%")),
            size = 3, color = "black", fontface = "bold") +  
  scale_fill_manual(values = party_colors, na.value = "grey") +
  theme_void() +
  theme(
    plot.title = element_text(size = 38, face = "bold"),
    legend.title = element_text(size = 30),
    legend.text = element_text(size = 27)
  ) +
  labs(title = "National Council Elections 2023: Strongest Party by Canton",
       fill = "Strongest Party")

ggsave("plots/map.png", plot = plot1, width = 15, height = 10, dpi = 600)
