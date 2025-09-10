
# Cargar librerías --------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)
library(esquisse)
library(fs)
library(glue)

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

cuenca_maipo_limpio <- cuenca_maipo %>%
  mutate(
    agu_fecha = ymd(agu_fecha),
    agu_hora = hm(agu_hora),
    agu_valor = as.numeric(agu_valor)
  )

cuenca_maipo_descripcion <- cuenca_maipo_limpio %>%
  left_join(parametros, join_by("par_codigo" == "codigo")) %>%
  left_join(estaciones, join_by("est_codigo" == "codigo"))

wide_por_anio <- cuenca_maipo_descripcion %>%
  mutate(anio = lubridate::year(agu_fecha)) %>%
  group_by(anio, descripcion) %>%
  summarise(n = n(), .groups = "drop") %>%
  pivot_wider(
    id_cols = anio,
    names_from = descripcion,
    values_from = n,
    values_fill = 0 # si no hay, no se midió
  ) %>%
  clean_names()

long_por_anio <-
wide_por_anio %>%
  pivot_longer(-anio, names_to = "parametro", values_to = "n")
