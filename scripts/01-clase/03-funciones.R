# Crear una funcion en R --------------------------------------------------

# Accion (nombre): multiplicar_por_10
# Argumento: x (debe ser un número)
# Cuerpo: operación x * 10
# Salida: el resultado de esa operación

multiplicar_por_10 <- function(x) {
  x * 10
}

multiplicar_por_10(3.5)

# Creo un vector ----------------------------------------------------------

vector <- 1:10 # operador : inicio:fin con enteros

# Creo una lista

lista <- list(numeros = 1:10)

lista_ejemplo <- list(numeros = as.numeric(1:10),
              letras = c("A", "B"))

# Usemos la funcion -------------------------------------------------------

multiplicar_por_10(vector) # 😮

# Existe una funcion llamada map que nos ayuda ----------------------------

purrr::map(vector, multiplicar_por_10) # 😔 una lista?

purrr::map_dbl(vector, multiplicar_por_10) # 🙂 funciona!

purrr::map(lista, multiplicar_por_10) # 🙂 funciona con listas!

# Funciones anónimas ------------------------------------------------------

# multiplicar por 10 tiene nombre

purrr::map_dbl(vector, ~ .x * 10)   # función anónima
# funcion map(vector, ~ cuerpo funcion con .x)

# ~ .x * 10  función anónima que toma un valor y lo multiplica por 10.
# .x representa los valores

# Porqué? -----------------------------------------------------------------
# Para avanzar en funcionalidades en R es útil saber listas
# por ejemplo, ggplot como objeto es una lista

pH_estacion_5722002 <-
cuenca_maipo_limpio %>%
  filter(par_codigo == 6020 & est_codigo == 5722002) %>%
  filter(agu_valor < 14 & agu_valor > 2) %>% # revisar min y max
  ggplot(aes(x = agu_fecha, y = agu_valor)) +
  geom_point() +
  labs(x = "Fecha", y = "Valor pH", title = 5722002) +
  theme_bw()

print(pH_estacion_5722002)

class(pH_estacion_5722002) # estructura compleja

is.list(pH_estacion_5722002) # TRUE

# Quiero todas las subcuencas! --------------------------------------------

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
