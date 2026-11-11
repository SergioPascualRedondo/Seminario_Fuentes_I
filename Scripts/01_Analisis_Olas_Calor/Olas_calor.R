Slibrary(tidyverse)
library(jsonlite)

Olas_json <- fromJSON("INPUT/DATA/olas_calor_provincias_2020.json",
                      simplifyVector = TRUE)

names(Olas_json)#Muestra los nombres de los elementos que contiene el objeto 
Olas_json$nota #La nota avisa de que los días son una aproximación.

#Extraemos los datos de las olas de calor y creamos una tabla
Olas <- as_tibble(Olas_json$datos)
Olas
str(Olas)
summary(Olas)

#Cada fila es una provincia afectada
table(Olas$id_ola) #Cuántas veces aparece cada ola
table(Olas$provincia) #Cuántas olas afectan a cada provincia

Olas <- Olas %>%
  mutate(fecha_inicio  = as.Date(fecha_inicio),
         fecha_fin     = as.Date(fecha_fin),
         duracion_dias = as.integer(fecha_fin - fecha_inicio) + 1L,  # +1: cuentan ambos días
         ola           = paste("Ola", id_ola))

str(Olas)

Olas %>% distinct(ola, fecha_inicio, fecha_fin, duracion_dias)

#Como el json solo contiene las provincias y no dice las comunidades autónomas las tenemos que crear
Provincias <- tribble(
  ~cpro, ~provincia,       ~ccaa,
  "01", "ARABA/ALAVA",     "País Vasco",
  "02", "ALBACETE",        "Castilla-La Mancha",
  "03", "ALICANTE",        "Comunitat Valenciana",
  "04", "ALMERIA",         "Andalucía",
  "05", "AVILA",           "Castilla y León",
  "06", "BADAJOZ",         "Extremadura",
  "07", "BALEARES",        "Illes Balears",
  "08", "BARCELONA",       "Cataluña",
  "09", "BURGOS",          "Castilla y León",
  "10", "CACERES",         "Extremadura",
  "11", "CADIZ",           "Andalucía",
  "12", "CASTELLON",       "Comunitat Valenciana",
  "13", "CIUDAD REAL",     "Castilla-La Mancha",
  "14", "CORDOBA",         "Andalucía",
  "15", "A CORUNA",        "Galicia",
  "16", "CUENCA",          "Castilla-La Mancha",
  "17", "GIRONA",          "Cataluña",
  "18", "GRANADA",         "Andalucía",
  "19", "GUADALAJARA",     "Castilla-La Mancha",
  "20", "GIPUZKOA",        "País Vasco",
  "21", "HUELVA",          "Andalucía",
  "22", "HUESCA",          "Aragón",
  "23", "JAEN",            "Andalucía",
  "24", "LEON",            "Castilla y León",
  "25", "LLEIDA",          "Cataluña",
  "26", "LA RIOJA",        "La Rioja",
  "27", "LUGO",            "Galicia",
  "28", "MADRID",          "Comunidad de Madrid",
  "29", "MALAGA",          "Andalucía",
  "30", "MURCIA",          "Región de Murcia",
  "31", "NAVARRA",         "Navarra",
  "32", "OURENSE",         "Galicia",
  "33", "ASTURIAS",        "Asturias",
  "34", "PALENCIA",        "Castilla y León",
  "35", "LAS PALMAS",      "Canarias",
  "36", "PONTEVEDRA",      "Galicia",
  "37", "SALAMANCA",       "Castilla y León",
  "38", "SANTA CRUZ DE TENERIFE", "Canarias",
  "39", "CANTABRIA",       "Cantabria",
  "40", "SEGOVIA",         "Castilla y León",
  "41", "SEVILLA",         "Andalucía",
  "42", "SORIA",           "Castilla y León",
  "43", "TARRAGONA",       "Cataluña",
  "44", "TERUEL",          "Aragón",
  "45", "TOLEDO",          "Castilla-La Mancha",
  "46", "VALENCIA",        "Comunitat Valenciana",
  "47", "VALLADOLID",      "Castilla y León",
  "48", "BIZKAIA",         "País Vasco",
  "49", "ZAMORA",          "Castilla y León",
  "50", "ZARAGOZA",        "Aragón",
  "51", "CEUTA",           "Ceuta",
  "52", "MELILLA",         "Melilla"
)

Olas %>% distinct(provincia) %>% anti_join(Provincias, by = "provincia") #Comprobamos que todas las provincias estan incluidas


#Olas y días de ola por provincia
Olas_prov <- Olas %>%
  group_by(provincia) %>%
  summarise(n_olas   = n_distinct(id_ola),
            dias_ola = sum(duracion_dias),
            .groups = "drop")

# Añadimos las provincias sin ola (con 0)
Resumen_prov <- Provincias %>%
  left_join(Olas_prov, by = "provincia", relationship = "one-to-one") %>%
  mutate(across(c(n_olas, dias_ola), ~ replace_na(.x, 0)))

Resumen_prov %>% arrange(desc(dias_ola))

#Olas y días de provincia por comunidad autónomica (Si 3 provincias de una CCAA están en la misma ola, se contaría 3 veces)
Olas_ccaa_ola <- Olas %>%
  left_join(Provincias, by = "provincia", relationship = "many-to-one") %>%
  distinct(ccaa, id_ola, ola, duracion_dias)

Resumen_ccaa <- Provincias %>%
  distinct(ccaa) %>%
  left_join(Olas_ccaa_ola %>%
              group_by(ccaa) %>%
              summarise(n_olas = n(), dias_ola = sum(duracion_dias),
                        .groups = "drop"),
            by = "ccaa") %>%
  mutate(across(c(n_olas, dias_ola), ~ replace_na(.x, 0)))

Resumen_ccaa %>% arrange(desc(dias_ola))

#Gráfico de días de ola por CCAA
G1 <- Olas_ccaa_ola %>%
  ggplot(data = ., mapping = aes(x = reorder(ccaa, duracion_dias, sum),
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

#Grafico numero de olas de calor por provincia 
Olas_provincia <- Olas %>% 
  group_by(provincia) %>%                   
  summarise(
    numero_olas = n_distinct(ola)            
  )

G2 <- ggplot(data = Olas_provincia,
             mapping = aes(x = reorder(provincia, numero_olas),
                           y = numero_olas)) + 
  geom_bar(stat = "identity", fill = "orange")  +                 
  coord_flip() +                              
  scale_y_continuous(breaks = 0:3) +          
  labs(x = "Provincia",
       y = "Número de olas de calor",
       title = "Olas de calor por provincia (2020)") +
  theme_classic()                             

G2                       

#Exportación de gráficos
ggsave("SALIDA/FIGURAS/G1_olas_CCAA.png",
       plot = G1,                    
       width = 9, height = 6, dpi = 300) 

ggsave("SALIDA/FIGURAS/G2_olas_CCAA.png",
       plot = G2,                    
       width = 9, height = 8, dpi = 300) 




