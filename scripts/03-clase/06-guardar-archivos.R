
# Ejemplo estaciones maipo ------------------------------------------------

estaciones_maipo <- unique(cuenca_maipo_limpio$est_codigo) # son 189

# podria ser distinct

pH_estaciones_maipo <- map(estaciones_maipo, ~ {
  cuenca_maipo_limpio %>%
    filter(par_codigo == 6020 & est_codigo == .x) %>%
    filter(agu_valor < 14 & agu_valor > 2) %>%
    ggplot(aes(x = agu_fecha, y = agu_valor)) +
    geom_point() +
    labs(x = "Fecha", y = "Valor pH", title = .x) +
    theme_bw()
})

pH_estaciones_maipo[[189]]

cuenca_maipo_limpio %>%
  filter(par_codigo == 6020, est_codigo == "5713003") %>%
  summarise(fecha_min = min(agu_fecha, na.rm = TRUE),
            fecha_max = max(agu_fecha, na.rm = TRUE))

# Exportar archivos -------------------------------------------------------

lista_ejemplo_nombres <- list(a = 10, b = 20, c = 30)
names(lista_ejemplo_nombres)

iwalk(lista_ejemplo, ~ {
  print(glue::glue("{.x}, {.y}"))
})

lista_ejemplo_sin_nombres <- list(10, 20, 30)
names(lista_ejemplo_sin_nombres)

iwalk(lista_ejemplo_sin_nombres, ~ {
  print(glue::glue("{.x}, {.y}"))
}) # algo hace, pero pone numeros

# -------------------------------------------------------------------------

names(pH_estaciones_maipo) # ! necesito nombres

names(pH_estaciones_maipo) <- estaciones_maipo

names(pH_estaciones_maipo)

iwalk(
  pH_estaciones_maipo,
  ~ {
    # una carpeta por estacion
    carpeta <- glue("outputs/pH_estaciones_maipo/{.y}")
    dir_create(carpeta)

    # nombre de archivo con fecha de inicio y termino
    rango <- cuenca_maipo_limpio %>%
      filter(par_codigo == 6020, est_codigo == .y) %>%
      summarise(fecha_min = min(agu_fecha, na.rm = TRUE),
                fecha_max = max(agu_fecha, na.rm = TRUE))

    # nombre de archivo con glue
    nombre_archivo <- glue("{carpeta}/ph_{.y}_{format(rango$fecha_min, '%Y')}_{format(rango$fecha_max, '%Y')}.png")

    ggsave(
      filename = nombre_archivo,
      plot     = .x,
      width    = 7, height = 4.5, dpi = 300
    )
  }
)

