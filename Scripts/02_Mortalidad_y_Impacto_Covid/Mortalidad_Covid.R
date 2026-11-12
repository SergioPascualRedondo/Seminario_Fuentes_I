library(tidyverse)

#Gráfico 3: aumento de defunciones por CCAA
G3 <- datos_unidos %>%
  mutate(ccaa = reorder(ccaa, var_defunciones)) %>% 
  ggplot(mapping = aes(x = ccaa, y = var_defunciones)) +
  geom_segment(mapping = aes(xend = ccaa, yend = 0),
               colour = "grey") +                
  geom_point(size = 4, colour = "lightblue") +     
  geom_text(mapping = aes(label = var_defunciones),
            hjust = -0.5, size = 3) +               
  coord_flip() +                                    
  scale_y_continuous(expand = expansion(mult = c(0, .15))) +
  labs(x = "CCAA",
       y = "Aumento de defunciones (2020 respecto a 2019)",
       title = "Aumento de defunciones por Comunidad Autónoma (2020)") +
  theme_minimal()                                  

G3  

#Gráfico 4: aumento de defunciones por COVID y otras causas
#Antes cremos una tabla para separar las muertes causadas por covid y por otras causas
muertes_causa <- bind_rows(
  datos_unidos %>% transmute(ccaa, causa = "COVID-19",
                             defunciones = muertes_covid),
  datos_unidos %>% transmute(ccaa, causa = "No COVID-19",
                             defunciones = diferencia_muertes_NoCovd)
)

G4 <- muertes_causa %>%
  ggplot(mapping = aes(x = reorder(ccaa, defunciones, sum),
                       y = defunciones, fill = causa)) +
  geom_col() +                                          
  coord_flip() +                                        
  scale_fill_manual(values = c("COVID-19" = "green",
                               "No COVID-19" = "blue")) + 
  labs(x = "CCAA",
       y = "Aumento de defunciones (2020 respecto a 2019)",
       fill = "",
       title = "Aumento de defunciones en 2020: COVID-19 y resto") +
  theme_minimal()                                       

G4   

#Gráfico G5: proporción del aumento de defunciones correspondientes al covid.
datos_g5 <- datos_unidos %>%
  summarise(
    COVID = sum(muertes_covid),                 
    No_COVID = sum(diferencia_muertes_NoCovd)   
  ) %>%
  pivot_longer(cols = everything(),             
               names_to = "causa",               
               values_to = "defunciones")       
G5 <- ggplot(data = datos_g5,
             mapping = aes(x = "", y = defunciones, fill = causa)) +
  geom_bar(stat = "identity", width = 1) +      
  coord_polar("y") +                           
  scale_fill_manual(values = c("COVID" = "purple",
                               "No_COVID" = "yellow")) +
  labs(fill = "Causa",
       title = "Distribución del aumento de defunciones según causa (2020)") +
  theme_void()                                 

G5

#Gráfico 6:relación entre defunciones por covid y aumento total
limites <- range(c(datos_unidos$var_defunciones,
                   datos_unidos$muertes_covid), na.rm = TRUE)

linea_referencia <- data.frame(
  x_inicio = limites[1],
  y_inicio = limites[1],
  x_fin = limites[2],
  y_fin = limites[2]
)

G6 <- datos_unidos %>%
  ggplot(mapping = aes(x = var_defunciones,
                       y = muertes_covid)) +       
  geom_segment(data = linea_referencia,
               mapping = aes(x = x_inicio, y = y_inicio,
                             xend = x_fin, yend = y_fin),
               inherit.aes = FALSE,
               linetype = "dashed",
               colour = "blue") +                
  geom_point(size = 3, colour = "orange") +    
  geom_text(mapping = aes(label = ccaa),
            vjust = -0.8, size = 3,
            check_overlap = TRUE) +                
  labs(x = "Aumento total de defunciones (2020 respecto a 2019)",
       y = "Defunciones por COVID-19",
       title = "Defunciones por COVID-19 frente al aumento total",
       caption = "Línea discontinua: el COVID-19 explica todo el aumento") +
  theme_minimal()                                  

G6 

#Exportar gráficos
ggsave("SALIDA/FIGURAS/G3_aumento_defunciones.png",
       plot = G3, width = 9, height = 6, dpi = 300)

ggsave("SALIDA/FIGURAS/G4_apiladas_absolutas.png",
       plot = G4, width = 9, height = 6, dpi = 300)

ggsave("SALIDA/FIGURAS/G5_apiladas_porcentaje.png",
       plot = G5, width = 9, height = 6, dpi = 300)

ggsave("SALIDA/FIGURAS/G6_dispersion_covid.png",
       plot = G6, width = 8, height = 6, dpi = 300)