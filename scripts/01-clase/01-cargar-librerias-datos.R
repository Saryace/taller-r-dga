# Cargar librerías --------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)

# Como instalar una libreria en R -----------------------------------------
# Una vez en la consola, ejecutar install.packages("readxl")

# Como hacer secciones en el codigo ---------------------------------------
# CMD (o CTRL) + SHIFT + R

# Como formatear código ---------------------------------------------------
# instalar la libreria styler
# en Addins -> style active file

# Cargar datos ------------------------------------------------------------
cuenca_maipo_crudo <- read_csv("datos/datos_Maipo.csv")

estaciones_crudo <- read_excel("datos/Estaciones2.xlsx")

parametros_crudo <- read_excel("datos/Parametros.xlsx")

# Coersion ----------------------------------------------------------------

# En R, la coerción es el proceso de forzar un dato de un tipo a otro.

# Cuando importamos datos, R intenta coercionar implícitamente los datos
# al tipo adecuado.

ejemplo_coersion <- c(1, 2, 3, 4, "V", 6, 7, 8)

class(ejemplo_coersion)

# Información de los datos: ver README ------------------------------------

# datos_Maipo: dataset tipo datos sin depurar
# EstCodigo: Código estacíon BNA sín dígito verificador
# ParCodigo: Código del parámetro
# AguFecha: Fecha
# AgProfundidad: Profundidad (m)
# AguValor: valor medido
# xIndChr: tipo de estación
# IndTipo: tipo de datos (censurados, dudosos, etc.)
# orden: número de fila de dataset original (ID)

# estaciones: dataset de códigos y estaciones nacionales
# hoja "Nacional", columnas Código y Estación

# parametros: Código, Descripción y Unidadf (unidad final)

# Glimpse -----------------------------------------------------------------

glimpse(cuenca_maipo_crudo)

glimpse(estaciones_crudo)

glimpse(parametros_crudo)

# Comas? Puntos? podemos definirlo ----------------------------------------
# pero SOLO con csv (texto), xlsx ya viene con encoding

configuracion_local <- locale(
  decimal_mark = ",", # decimales usan coma
  grouping_mark = ".", # miles usan punto
  encoding = "UTF-8" # Se usan ñ y caracteres
)

# Cargar los datos asegurandonos de obtener los datos  --------------------
# Usar argumentos de funciones de importar para crear objetos óptimos
# Si hay sospechas se puede perder info (por ejemplo perder ceros a la izq),
# siempre es mejor importar como chr

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

# me quedo solo con los objetos limpios -----------------------------------
# no es buena práctica, lo hacemos solo para el taller
rm(
  "ejemplo_coersion",
  cuenca_maipo_crudo,
  estaciones_crudo,
  parametros_crudo
)

# Que paquetes usamos? ----------------------------------------------------
# Es buena práctica saber que estamos usando

sessionInfo() # impreso consola

writeLines(capture.output(sessionInfo()), "session_info.txt") # se guarda

