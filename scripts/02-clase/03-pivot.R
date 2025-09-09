# Librerias ---------------------------------------------------------------
library(broom) # ordena output de estadistica en R

# Datos Wide o Long? ------------------------------------------------------

glimpse(cuenca_maipo_descripcion)

# -------------------------------------------------------------------------

# Podemos decir que es Long, siendo a lo largo con los parametros medidos
# pasar a Wide consolidando columnas

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

# Razones? ----------------------------------------------------------------
# wide deja columnas para modelacion estadistica

lm(
  bicarbonato ~ c_loruro + calcio_disuelto +
    carbonato + magnesio_disuelto,
  data = wide_por_anio
) %>% tidy()

lm(
  bicarbonato ~ c_loruro + calcio_disuelto +
    carbonato + magnesio_disuelto,
  data = wide_por_anio
) %>% glance()


# Extra -------------------------------------------------------------------

# instalar remotes::install_github("datalorax/equatiomatic")

modelo_bicarbonato <- lm(
  bicarbonato ~ c_loruro + calcio_disuelto +
    carbonato + magnesio_disuelto,
  data = wide_por_anio
)

equatiomatic::extract_eq(modelo_bicarbonato, wrap = TRUE)

# el output en la consola es LaTex.
# Lo copias sin los signos pesos en https://latexeditor.lagrida.com/
# y obtienes la formula

# Volvamos a long ---------------------------------------------------------

long_por_anio <- wide_por_anio %>%
  pivot_longer(
    cols = -anio,                  # todas las columnas menos "anio"
    names_to = "parametro",        # nombre de la variable
    values_to = "conteo"           # valor de la celda
  )
