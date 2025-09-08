
# Comenzamos con los datos de la cuenca del maipo -------------------------
# Es importante considerar información de los datos para limpiar
# Fechas: año - mes - dia = YMD
# código estación es número o chr? depende

cuenca_maipo_limpio <- cuenca_maipo %>%
  mutate(
    agu_fecha = ymd(agu_fecha),
    agu_hora = hm(agu_hora),
    agu_valor = as.numeric(agu_valor)
  )

# Resumen descriptivo -----------------------------------------------------
# Cuantas mediciones por parametro por año
# funciones de tidyverse

cuenca_maipo_limpio %>%
  mutate(anio = year(agu_fecha)) %>% # crea nueva col
  group_by(par_codigo, anio) %>% # opera como agregador
  summarise(n = n()) # n = n() = "contar"

# Tipos de estaciones en la cuenca?

cuenca_maipo_limpio %>%
  count(x_ind_chr)

# Que parámetro es el más consistentemente medido en la cuenca? -----------

cuenca_maipo_limpio %>%
  mutate(anio = year(agu_fecha)) %>%
  group_by(par_codigo, anio) %>%
  summarise(n = n()) %>%
  ungroup() %>% # nos aseguramos que no haga doble grupo
  group_by(par_codigo) %>%
  summarise(
    n_anios = n_distinct(anio), # cuenta obs única
    total_n = sum(n) # suma en este caso "n" = totales
  ) %>%
  arrange(desc(total_n)) # arrange(desc()) = mayor a menor

# Exportar información  ---------------------------------------------------
# write_csv() usa estilo USA (punto decimal, coma separador)
# write_csv2() usa europa/chile (coma decimal, ; separador)
# nota: mi compu está en inglés!
# revisar cada configuración 🔎

write_csv(cuenca_maipo_limpio,
          "outputs/csv_procesados/cuenca_maipo_limpio.csv")
