
# librerias ---------------------------------------------------------------
library(tidyverse)
library(quarto)
library(glue)
library(fs)

# Vamos! ------------------------------------------------------------------

parametros_defecto <- c("6020", "5020")  # los del archivo quarto

estaciones_iterar <- unique(cuenca_maipo_limpio$est_codigo) %>%
                     head(5) # solo 5 por tiempo

dir.create("outputs/reportes-pdf", recursive = TRUE, showWarnings = FALSE)

purrr::walk(
  estaciones_iterar,
  ~ quarto::quarto_render(
    input = "reporte_por_estacion.qmd",
    execute_params = list(
      est_codigo = as.character(.x),
      par_codigo = parametros_defecto
    ),
    metadata = list(
      title = glue("Reporte por estación {as.character(.x)} - Cuenca del Maipo")
    ),
    output_file = glue("reporte_{.x}.pdf")
  )
)
