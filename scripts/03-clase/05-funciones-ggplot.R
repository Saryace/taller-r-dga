# Personalizar funciones --------------------------------------------------

# lm dos metales totales --------------------------------------------------

wide_por_anio %>%
  select(anio, ends_with("_total")) %>%
  ggplot(aes(x = cobre_total, y = arsenico_total)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  theme_bw()

# Crear funcion dos parametros x e y --------------------------------------

ggplot_funcion_corr_totales = function(x, y) {
  wide_por_anio %>%
    select(anio, ends_with("_total")) %>%
    ggplot(aes(x = .data[[x]], y = .data[[y]])) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE) +
    theme_bw()
}

ggplot_funcion_corr_totales(x = "plomo_total", y = "cadmio_total")

# Crear funcion 1 parametro -----------------------------------------------

ggplot_funcion_anual_totales = function(x) {
  wide_por_anio %>%
    select(anio, ends_with("_total")) %>%
    ggplot(aes(x = anio, y = .data[[x]], group = anio)) +
    geom_col() +
    theme_bw()
}

ggplot_funcion_anual_totales(x = "magnesio_total")

