
# Library -----------------------------------------------------------------
library(esquisse)
library(ggx)

# Esquisser ---------------------------------------------------------------

esquisse::esquisser(long_por_anio)

# Que plot elegir? --------------------------------------------------------

# https://clauswilke.com/dataviz/directory-of-visualizations.html

# ggx ---------------------------------------------------------------------

long_por_anio %>%
  filter(parametro == "ph") %>%
  ggplot(aes(x = anio, y = n)) +
  geom_line(color = "blue") +
  geom_point(color = "red", size = 2) +
  labs(
    title = "Evolución de lecturas anuales de pH",
    x = "Año",
    y = "Número"
  ) +
  theme_bw()

gghelp("remove legend")
gghelp("Rotate x-axis 45 degrees")
gghelp("increase font size x axis")


