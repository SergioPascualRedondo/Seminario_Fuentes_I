
datos_g7 <- datos_unidos %>%
  mutate(
    defunciones_no_covid_100000 =
      diferencia_muertes_NoCovd / poblacion * 100000
  ) %>%
  filter(
    !is.na(dias_ola_media),
    !is.na(defunciones_no_covid_100000)
  )

G7 <- ggplot(datos_g7,aes(x = dias_ola_media,
                          y = defunciones_no_covid_100000 )) +
  geom_hline(yintercept = 0,linetype = "dashed",colour = "grey60") +
  geom_point(colour = "orange",size = 3 ) +
  geom_smooth( method = "lm", se = TRUE, colour = "blue" ) +
  geom_text(aes(label = ccaa),vjust = -0.8,size = 3,check_overlap = TRUE) +
  scale_x_continuous(expand = expansion(mult = c(0.03, 0.12))) +
  labs(
    title = "Olas de calor y variación de defunciones no COVID-19",
    subtitle = "Datos ajustados por población; cada punto representa una comunidad autónoma",
    x = "Media de días de ola de calor por provincia",
    y = "Variación de defunciones no COVID-19 por 100.000 habitantes",
    caption = "La recta muestra una asociación estadística, no necesariamente causal"
  ) +
  theme_minimal()




# Gráfico 10: variación de defunciones según la inclusión
# en las olas nacionales de AEMET

exposicion <- exceso_no_covid %>%
  group_by(ccaa) %>%
  summarise(dias_ola_total = sum(dias_ola), .groups = "drop") %>%
  mutate(
    grupo = ifelse(
      dias_ola_total > 0,
      "Incluidas en alguna ola nacional",
      "No incluidas en las olas nacionales"
    )
  )

lineas <- exceso_no_covid %>%
  left_join(exposicion, by = "ccaa") %>%
  group_by(grupo, semana, fecha_2020) %>%
  summarise(
    tasa = sum(variacion_no_covid) / sum(poblacion) * 1e5,
    .groups = "drop"
  ) %>%
  filter(semana >= 22, semana <= 38) #periodo de estudio del verano

lineas

olas_fechas <- olas %>%
  distinct(id_ola, fecha_inicio, fecha_fin)

olas_fechas

G10<- ggplot(lineas, aes(x = fecha_2020, y = tasa, colour = grupo)) +
  geom_rect(data = olas_fechas,
            aes(xmin = fecha_inicio, xmax = fecha_fin, ymin = -Inf, ymax = Inf),
            inherit.aes = FALSE,  #utilizamos FALSE ya que vamos a crear una capa independiente encima
            fill = "orange", alpha = 0.3) +
  geom_hline(yintercept = 0, colour = "grey60") +
  geom_line(linewidth = 1) +
  labs(x = "", y = "Variación no COVID por 100.000 hab. (frente a 2019)", colour = "") +
  theme_minimal() 

G10
#el 0 en el gráfico significa que las muertes en 2020 y 2019 se mantuvieron igual. Por encima del 0
#hubo más muertes en 2020 que 2019 y por debajo al contrario





#Gráfico 9: Variacion defuncion no covid en cada ccaa + olas de calor
ventanas <- exceso_no_covid %>%
  filter(semana >= 22, semana <= 38) %>%
  left_join(olas_ccaa %>% select(ccaa, dias_ola_media), by = "ccaa") %>%
  mutate(ccaa = fct_reorder(ccaa, -dias_ola_media))      #de más a menos calor

olas_ventanas <- olas %>%
  left_join(prov_ccaa, by = "provincia") %>%
  distinct(ccaa, id_ola, fecha_inicio, fecha_fin) %>%
  mutate(ccaa = factor(ccaa, levels = levels(ventanas$ccaa))) #los niveles van a a ser las ccaa de cada ventana

G9 <- ggplot(ventanas, aes(x = fecha_2020, y = variacion_no_covid_100k)) +
  geom_rect(data = olas_ventanas,
            aes(xmin = fecha_inicio, xmax = fecha_fin, ymin = -Inf, ymax = Inf),
            inherit.aes = FALSE, fill = "orange", alpha = 0.3) +
  geom_hline(yintercept = 0, colour = "grey60") +
  geom_line() +
  facet_wrap(vars(ccaa), ncol = 4, scales = "free_y") +
  scale_x_date(date_breaks = "1 month", date_labels = "%m") +
  labs(title = "Variación de defunciones no COVID-19 por comunidad en el verano de 2020",
       subtitle = "Franjas naranjas: olas de calor de cada comunidad; comunidades ordenadas de más a menos calor",
       x = "Mes", y = "Variación por 100.000 hab. (frente a 2019)") +
  theme_minimal()
G9
#EXPORTACION

G7
ggsave("SALIDA/FIGURAS/Pregunta_4/G7_calor_mortalidad_no_covid.png",
       plot = G7, width = 9, height = 6, dpi = 300)


ggsave("SALIDA/FIGURAS/G10_var_defunciones_ola.png",
       plot = G10, width = 9, height = 6, dpi = 300)

ggsave("SALIDA/FIGURAS/Pregunta_4/G9_facetas.png",
       plot = G9, width = 9, height = 6, dpi = 300)
