
# Opciones avanzadas ------------------------------------------------------

# Usar pipes dentro de ggplot ---------------------------------------------
top_parametros <- wide_por_anio %>%
  pivot_longer(-anio, names_to = "parametro", values_to = "n") %>%
  group_by(parametro) %>%
  summarise(total = sum(n, na.rm = TRUE), .groups = "drop") %>%
  slice_max(total, n = 20) %>%
  pull(parametro) #solo la variable como vector (attach)

ggplot(
  filter(
    wide_por_anio %>%
      pivot_longer(-anio, names_to = "parametro", values_to = "n"),
    parametro %in% top_parametros
  ),
  aes(
    x = anio,
    y = fct_reorder(parametro, n, .fun = sum),
    fill = n
  )
) +
  geom_tile() +
  scale_fill_viridis_c(option = "C", na.value = "grey95") +
  labs(x = "Año", y = NULL, fill = "n") +
  theme_minimal()

# Operaciones dentro ggplot -----------------------------------------------
# Quiero graficar solo cationes específicos
# Quiero expresar en ppb en lugar de ppm
# Escala log
# Temporalidad

metales <- tibble(descripcion = c("cobre_total","plomo_total","arsenico_total"),
                   par_codigo = c("8145", "8383","8041"))

# Mi primer intento -------------------------------------------------------

cuenca_maipo_descripcion %>%
  filter(par_codigo %in% metales$par_codigo) %>%
  ggplot(aes(x = agu_fecha, y = agu_valor * 1000)) +
  geom_point(aes(color = descripcion)) +
  scale_y_log10() # log10(x) valido solo x > 0

# Segundo intento ---------------------------------------------------------

plot_metales <-
cuenca_maipo_descripcion %>%
  filter(par_codigo %in% metales$par_codigo) %>%
  filter(agu_valor > 0) %>%
  ggplot(aes(x = agu_fecha, y = agu_valor * 1000)) +
  geom_point(aes(color = descripcion)) +
  scale_y_log10() +
  scale_color_manual(
    name = "[ppb]",
    values = c(
      "Cobre Total" = "blue",
      "Plomo Total" = "green",
      "Arsenico Total"   = "orange"),
    labels = c("Cu", "Pb", "As")
  ) +
  labs(x = "Fecha Medición", y = "Concentración (ppb)") +
  theme_bw()

# Tercer Intento ----------------------------------------------------------

plot_metales +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Podemos seguir iterando!


