
# Esquisser ---------------------------------------------------------------

esquisse::esquisser(cuenca_maipo_descripcion)


# Que plot elegir? --------------------------------------------------------

# https://clauswilke.com/dataviz/directory-of-visualizations.html


# Ejemplo -----------------------------------------------------------------

top_parametros <- wide_por_anio %>%
  pivot_longer(-anio, names_to = "parametro", values_to = "n") %>%
  group_by(parametro) %>%
  summarise(total = sum(n, na.rm = TRUE), .groups = "drop") %>%
  slice_max(total, n = 20) %>%
  pull(parametro) #solo la variable como vector


# Usar pipes dentro de ggplot ---------------------------------------------

ggplot(
  filter(
    wide_por_anio %>%
      pivot_longer(-anio, names_to = "parametro", values_to = "n"),
    parametro %in% top_parametros
  ),
  aes(
    x = anio,
    y = fct_reorder(parametro, n, .fun = sum, .desc = TRUE),
    fill = n
  )
) +
  geom_tile() +
  scale_fill_viridis_c(option = "C", na.value = "grey95") +
  labs(x = "Año", y = NULL, fill = "n") +
  theme_minimal()

