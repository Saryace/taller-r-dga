
# Operaciones Join --------------------------------------------------------

cuenca_maipo_limpio <- cuenca_maipo %>%
  mutate(
    agu_fecha = ymd(agu_fecha),
    agu_hora = hm(agu_hora),
    agu_valor = as.numeric(agu_valor)
  )

# Parametros --------------------------------------------------------------

glimpse(parametros)

glimpse(cuenca_maipo_limpio)

glimpse(estaciones)

# Columna ID --------------------------------------------------------------

# para parametros = codigo
# para cuenca_maipo_limpio = par_codigo

# podemos conectar parametros <=> cuenca_maipo_limpio
# tambien podemos conectar estaciones <=> cuenca_maipo_limpio

# Join --------------------------------------------------------------------

cuenca_maipo_limpio %>%
  left_join(parametros) # qué pasó!

cuenca_maipo_descripcion <- cuenca_maipo_limpio %>%
  left_join(parametros, join_by("par_codigo" == "codigo")) %>%
  left_join(estaciones, join_by("est_codigo" == "codigo"))

# Join para analizar datos ------------------------------------------------
# Ejemplo inner_join
# Une dos data frames devolviendo solo las filas que coinciden
# Si una fila está en una tabla pero no en la otra, se descarta.

glimpse(cuenca_maipo_limpio)

cuenca_maipo_limpio %>%
  inner_join(parametros, join_by("par_codigo" == "codigo")) %>%
  glimpse()

# row encuenca_maipo_limpio cuyo par_codigo existe en parametros.
# agrega unidad del parámetro y descripcion

cuenca_maipo_limpio %>%
  anti_join(parametros, join_by("par_codigo" == "codigo")) %>%
  glimpse()

# lo contrario: row de cuenca_maipo_limpio cuyo par_codigo no aparece
# en parametros







