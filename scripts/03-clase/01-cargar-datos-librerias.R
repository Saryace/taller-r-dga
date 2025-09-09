
# Cargar librerías --------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)
library(esquisse)

# Cargar datos ------------------------------------------------------------

configuracion_local <- locale(
  decimal_mark = ",", # decimales usan coma
  grouping_mark = ".", # miles usan punto
  encoding = "UTF-8" # Se usan ñ y caracteres
)

cuenca_maipo <- read_csv(
  "datos/datos_Maipo.csv",
  col_types = cols(.default = col_character()),
  locale = configuracion_local
) %>%
  clean_names() %>%
  select(-x1, -orden)

estaciones <- read_excel("datos/Estaciones2.xlsx",
                         range = cell_cols(c("A", "B")),
                         col_types = "text"
) %>%
  clean_names()

parametros <- read_excel("datos/Parametros.xlsx",
                         skip = 6,
                         col_types = "text"
) %>%
  clean_names() %>%
  select(codigo, descripcion, unidadf)

# Datos con descripcion ---------------------------------------------------

cuenca_maipo_descripcion <- cuenca_maipo_limpio %>%
  left_join(parametros, join_by("par_codigo" == "codigo")) %>%
  left_join(estaciones, join_by("est_codigo" == "codigo"))
