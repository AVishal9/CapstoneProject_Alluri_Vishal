# Load necessary libraries
library(dplyr)
library(sf)
library(ggplot2)
library(rio)

# Import election results data
election_data <- rio::import("data/election_data.csv")

# Filter for canton-level results (based on kanton_nummer and kanton_bezeichnung)
canton_results <- election_data %>%
  filter(!is.na(kanton_nummer), flag_staerkste_partei == 1)

# Check if the filtering is done correctly
head(canton_results)

# Import canton shapefile
cantons_shp <- st_read("data/boundaries.shp/swissBOUNDARIES3D_1_5_TLM_KANTONSGEBIET.shp")

# Transform CRS to WGS84
cantons_shp <- st_transform(cantons_shp, crs = 4326)

# Convert geometries to 2D (XY)
cantons_shp <- st_zm(cantons_shp, drop = TRUE, what = "ZM")

# Check and fix column types if necessary
canton_results$kanton_nummer <- as.integer(canton_results$kanton_nummer)

# Join election data with shapefile using kanton_nummer
cantons_with_results <- left_join(cantons_shp, canton_results, by = c("KANTONSNUM" = "kanton_nummer"))


head(cantons_with_results)
st_geometry(cantons_with_results)

# Remove invalid geometry
cantons_with_results <- cantons_with_results %>%
  filter(!st_is_empty(geometry))

#Color for parties
party_colors <- c("FDP" = "blue", "SP" = "red", "SVP" = "green", "GRÜNE" = "darkgreen", "GLP" = "yellow", "Mitte" = "orange")

plot1 <- ggplot(cantons_with_results) +
  geom_sf(aes(fill = partei_bezeichnung_en)) +
  scale_fill_manual(values = party_colors, na.value = "grey") +
  theme_minimal() +
  labs(title = "National Council Elections 2023: Strongest Party by Canton",
       fill = "Strongest Party")

ggsave("plots/map.png", plot = plot1)
