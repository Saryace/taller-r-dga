# Librerias ---------------------------------------------------------------
library(tidyverse)
library(terra)
library(sf)
library(ggspatial)
library(giscoR)
library(grid)

# Datos -------------------------------------------------------------------

sf::sf_use_s2(FALSE) # ajustes geometria estándar


# Descarga de datos -------------------------------------------------------

# gadm41_CHL_shp
# https://geodata.ucdavis.edu/gadm/gadm4.1/shp/gadm41_CHL_shp.zip
# SubCuencas_BNA
# https://www.geoportal.cl/geoportal/catalog/35266/Subcuencas
# HydroRIVERS
# https://data.hydrosheds.org/file/HydroRIVERS/HydroRIVERS_v10_sa_shp.zip

# descomprimir y dejar en la carpeta datos antes de ejecutar el código
# -------------------------------------------------------------------------
regiones <-
  st_read("datos/gadm41_CHL_shp/gadm41_CHL_1.shp", quiet = TRUE)  %>%
  st_make_valid() # repara geometrias

araucania <- regiones %>%
  filter(NAME_1 == "Araucanía") %>%
  st_transform(4326)

cuencas <- st_read("datos/SubCuencas_BNA/SubCuencas_BNA.shp", quiet = TRUE) %>%
  st_transform(4326)

rios <- st_read("datos/HydroRIVERS_v10_sa_shp/HydroRIVERS_v10_sa.shp", quiet = TRUE) %>%
  st_transform(4326)

# Intersección (solo araucania) -------------------------------------------

cuencas_araucania <- st_intersection(cuencas, araucania)

rios_araucania <- st_intersection(rios, araucania)

rios_araucania <- rios_araucania %>% #grosor por orden
  mutate(grosor = case_when(
    ORD_FLOW >= 8 ~ 0.8,
    ORD_FLOW == 7 ~ 0.6,
    ORD_FLOW == 6 ~ 0.45,
    ORD_FLOW == 5 ~ 0.35,
    ORD_FLOW == 4 ~ 0.25,
    ORD_FLOW == 3 ~ 0.18,
    ORD_FLOW == 2 ~ 0.14,
    TRUE          ~ 0.10
  ))


# Centroide ---------------------------------------------------------------

centroide <- cuencas_araucania %>%
  group_by(OBJECTID) %>%
  summarise(geometry = st_union(geometry), .groups = "drop") %>%
  st_point_on_surface()

# Mapa ggplot + sf --------------------------------------------------------

ggplot() +
  geom_sf(data = cuencas_araucania,
          fill = "grey70",
          color = "white") +
  geom_sf(
    data = rios_araucania,
    color = "#145BBA",
    linewidth = rios_araucania$grosor,
    alpha = 0.9
  ) +
  geom_sf_label(
    data = centroide,
    aes(label = OBJECTID),
    size = 2,
    color = "grey20"
  ) +
  annotation_scale(
    location = "br",
    pad_x = unit(0.2, "cm"),
    pad_y = unit(0.2, "cm")
  ) +
  annotation_north_arrow(location = "tr", style = north_arrow_fancy_orienteering) +
  theme_void() +
  labs(title = "Subcuencas BNA - Región de la Araucanía",
       caption = "Fuentes: GADM 4.1 , Geoportal de Chile, HydroRIVERS",
       x = NULL, y = NULL)

