datos_g7 <- datos_unidos %>%
  mutate(
    defunciones_no_covid_100000 =
      diferencia_muertes_NoCovd / poblacion * 100000
  ) %>%
  filter(
    !is.na(dias_ola_media),
    !is.na(defunciones_no_covid_100000)
  )

G7 <- ggplot(
  datos_g7,
  aes(
    x = dias_ola_media,
    y = defunciones_no_covid_100000
  )
) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed",
    colour = "grey60"
  ) +
  geom_point(
    colour = "orange",
    size = 3
  ) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    colour = "blue"
  ) +
  geom_text(
    aes(label = ccaa),
    vjust = -0.8,
    size = 3,
    check_overlap = TRUE
  ) +
  scale_x_continuous(
    expand = expansion(mult = c(0.03, 0.12))
  ) +
  labs(
    title = "Olas de calor y variación de defunciones no COVID-19",
    subtitle = "Datos ajustados por población; cada punto representa una comunidad autónoma",
    x = "Media de días de ola de calor por provincia",
    y = "Variación de defunciones no COVID-19 por 100.000 habitantes",
    caption = "La recta muestra una asociación estadística, no necesariamente causal"
  ) +
  theme_minimal()

G7
Sggsave(
  "SALIDA/FIGURAS/G7_calor_mortalidad_no_covid.png",
  plot = G7,
  width = 9,
  height = 6,
  dpi = 300
)
