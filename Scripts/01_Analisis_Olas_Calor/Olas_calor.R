library(tidyverse)

#Tabla de días de ola por CCAA y ola (cada ola cuenta una vez por comunidad)
olas_ccaa_ola <- olas %>%
  left_join(prov_ccaa, by = "provincia") %>%
  distinct(ccaa, id_ola, duracion_dias) %>%
  mutate(ola = paste("Ola", id_ola))

#Gráfico de días de ola por CCAA
G1 <- ggplot(data = olas_ccaa_ola,
             mapping = aes(x = reorder(ccaa, duracion_dias, sum),
                           y = duracion_dias, fill = ola)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_fill_brewer(palette = "YlOrRd") +
  scale_y_continuous(expand = expansion(mult = c(0, .1))) +
  labs(x = "CCAA", 
       y = " Duración días ola de calor", 
       title = "Días asociados a cada ola de calor por Comunidad Autónoma (2020)") +
  theme_classic()

G1


G2 <- olas_prov %>%
  filter(n_olas > 0) %>%
  ggplot(mapping = aes(x = reorder(provincia, n_olas), y = n_olas)) +
  geom_bar(stat = "identity", fill = "orange")  +                 
  coord_flip() +                              
  scale_y_continuous(breaks = 0:3) +          
  labs(x = "Provincia",
       y = "Número de olas de calor",
       title = "Olas de calor por provincia (2020)") +
  theme_classic()                             

G2                       

#Exportación de gráficos
ggsave("Scripts/01_Analisis_Olas_Calor/G1_olas_CCAA.png",
       plot = G1,                    
       width = 9, height = 6, dpi = 300) 

ggsave("Scripts/01_Analisis_Olas_Calor/G2_olas_provincias.png",
       plot = G2,                    
       width = 9, height = 8, dpi = 300) 




