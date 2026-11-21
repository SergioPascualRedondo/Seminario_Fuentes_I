

library(tidyverse)
library(mapSpain)
library(plotly)


# Este script requiere que se hayan creado previamente:
# olas, prov_ccaa y olas_prov.


# Creamos la carpeta de salida si todavía no existe.

dir.create(
  "SALIDA/FIGURAS",
  recursive = TRUE,
  showWarnings = FALSE
)




# Cada ola se contabiliza una única vez por comunidad autónoma.

olas_ccaa_ola <- olas %>%
  left_join(
    prov_ccaa,
    by = "provincia"
  ) %>%
  distinct(
    ccaa,
    id_ola,
    duracion_dias
  ) %>%
  mutate(
    ola = paste("Ola", id_ola)
  )


G1 <- ggplot(
  data = olas_ccaa_ola,
  mapping = aes(
    x = reorder(ccaa, duracion_dias, sum),
    y = duracion_dias,
    fill = ola
  )
) +
  geom_col(position = position_dodge(preserve = "single")) +
  scale_fill_brewer(
    palette = "YlOrRd"
  ) +
  scale_y_continuous(
    expand = expansion(
      mult = c(0, 0.1)
    )
  ) +
  labs(
    x = "Comunidad autónoma",
    y = "Duración de la ola de calor (días)",
    fill = "Ola",
    title = paste(
      "Días asociados a cada ola de calor",
      "por comunidad autónoma (2020)"
    )
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

 


G1




# NÚMERO DE OLAS DE CALOR POR PROVINCIA

# Se muestran únicamente las provincias que registraron al menos una ola de calor.

G2 <- olas_prov %>%
  filter(
    n_olas > 0
  ) %>%
  ggplot(
    mapping = aes(
      x = reorder(provincia, n_olas),
      y = n_olas
    )
  ) +
  geom_col(
    fill = "orange"
  ) +
  coord_flip() +
  scale_y_continuous(
    breaks = 0:3
  ) +
  labs(
    x = "Provincia",
    y = "Número de olas de calor",
    title = "Olas de calor por provincia (2020)"
  ) +
  theme_minimal()


G2



# MAPA DE DÍAS DE OLA DE CALOR POR PROVINCIA


# Obtenemos las geometrías de las provincias españolas.
# Canarias se desplaza para obtener un mapa más compacto.

mapa_provincias <- mapSpain::esp_get_prov(
  moveCAN = TRUE,
  epsg = 4326
)


# Convertimos los nombres de provincia de olas_prov
# a códigos provinciales oficiales del INE.

olas_prov_mapa <- olas_prov %>%
  mutate(
    cpro = mapSpain::esp_dict_region_code(
      provincia,
      origin = "text",
      destination = "cpro"
    )
  ) %>%
  select(
    cpro,
    n_olas,
    dias_ola
  )


# Comprobamos si alguna provincia no ha sido reconocida.
# El resultado esperado es una tabla con cero filas.

olas_prov_mapa %>%
  filter(
    is.na(cpro)
  )


# Unimos los datos de las olas con las geometrías.

mapa_olas <- mapa_provincias %>%
  left_join(
    olas_prov_mapa,
    by = "cpro"
  ) %>%
  mutate(
    n_olas = replace_na(n_olas, 0),
    dias_ola = replace_na(dias_ola, 0),
    
    informacion = paste0(
      "<b>Provincia: ", ine.prov.name, "</b>",
      "<br>Días de ola: ", dias_ola,
      "<br>Número de olas: ", n_olas
    )
  )


# Creamos el mapa base con ggplot2.

G8 <- ggplot(
  data = mapa_olas
) +
  geom_sf(
    mapping = aes(
      fill = dias_ola,
      text = informacion
    ),
    color = "white",
    linewidth = 0.3
  ) +
  scale_fill_gradientn(
    colours = c(
      "#FFF7EC",
      "#FDD49E",
      "#FC8D59",
      "#D7301F",
      "#7F0000"
    ),
    name = "Días de ola"
  ) +
  labs(
    title = "Duración de las olas de calor por provincia",
    subtitle = "España, 2020",
    caption = paste(
      "El color representa el número total de días",
      "asociados a olas de calor"
    )
  ) +
  theme_minimal() +
  theme(
    legend.position = "right",
    
    plot.title = element_text(
      hjust = 0.5,
      face = "bold"
    ),
    
    plot.subtitle = element_text(
      hjust = 0.5
    )
  )


G8




# Convertimos el mapa de ggplot2 en un elemento interactivo.
# En el HTML se podrá ampliar, desplazar y consultar
# la información de cada provincia.

mapa_interactivo_olas <- plotly::ggplotly(
  G8,
  tooltip = "text"
) %>%
  plotly::config(
    scrollZoom = TRUE,
    displayModeBar = TRUE,
    responsive = TRUE
  )


mapa_interactivo_olas


# EXPORTACIÓN DE LOS GRÁFICOS


# Gráfico 1: olas por comunidad autónoma.

ggsave(
  filename = "SALIDA/FIGURAS/Pregunta_1/G1_olas_CCAA.png",
  plot = G1,
  width = 9,
  height = 6,
  dpi = 300
)


# Gráfico 2: número de olas por provincia.

ggsave(
  filename = "SALIDA/FIGURAS/Pregunta_1/G2_olas_provincias.png",
  plot = G2,
  width = 9,
  height = 8,
  dpi = 300
)


# Gráfico 8: versión estática del mapa.

ggsave(
  filename = "SALIDA/FIGURAS/Pregunta_1/G8_mapa_olas_provincias.png",
  plot = G8,
  width = 10,
  height = 7,
  dpi = 300
)


# Gráfico 8: versión interactiva en formato HTML.

htmlwidgets::saveWidget(
  widget = mapa_interactivo_olas,
  file = "SALIDA/FIGURAS/Pregunta_1/G8_mapa_interactivo_olas.html",
  selfcontained = TRUE
)