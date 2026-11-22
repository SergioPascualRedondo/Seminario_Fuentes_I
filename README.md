# CALOR, COVID Y MORTALIDAD EN ESPAÑA EN 2020

**Autores**: Laura Lasierra Gastón, Ángela Navarro Cantón y Sergio Pascual Redondo

**Curso Académico**: 2026/2027

**Grupo**: I

**Asignatura**: Fuentes de Datos Biomédicos y Web Semántica

---
<p align="center">
  <img src="INPUT/IMAGENES/wordcloud.png" width="450">
</p>

# 1. INTRODUCCIÓN

En este seminario se va a llevar a cabo una comprobación estadística de la relación entre las altas temperaturas, el covid y el aumento de la mortalidad en España en 2020.
En ese año, España vivió a la misma vez la primera y más grande oleada de casos de COVID-19 y un verano con varias olas de calor. Se sabe que el calor extremo lleva consigo
un aumento de la mortalidad, y que el COVID-19 provocó un incremento muy marcado de muertes con respecto a 2019, pero ambos fenómenos se solapan en el mismo año y puede ser 
complicado en algunos casos separar su efecto. No está claro si, una vez descontadas las muertes provocadas por el COVID-19, el aumento de defunciones que queda por comunidad
autónoma en 2020 con respecto a 2019 guarda relación con la exposición a olas de calor.


Vamos a estudiar esta cuestión con fuentes oficiales (AEMET e INE), utilizando R y datos en formato JSON, CSV y PC-AXIS.

# 2. OBJETIVOS

## OBJETIVO GENERAL

Analizar si el aumento de muertes en 2020 respecto a 2019 en las comunidades autónomas españolas se relaciona con las olas de calor, teniendo en cuenta las muertes por COVID-19.

## OBJETIVOS ESPECÍFICOS

1. ¿Cuántas olas de calor y cuántos días de ola se registraron en 2020 en cada provincia y CCAA?
2. ¿En qué comunidades aumentaron más las defunciones en 2020 respecto a 2019?
3. ¿Qué parte de ese aumento corresponden a muertes por COVID-19?
4. ¿Tiene relación ese aumento de muertes con las olas de calor?

## Metodología

Se realiza un estudio descriptivo y exploratorio de 2020 utilizando información
agregada por provincia y comunidad autónoma. Los datos proceden de cuatro
fuentes y se encuentran en diferentes formatos:

- Datos de olas de calor por provincia en formato JSON: listado de provincias afectadas en cada una de las tres olas de calor nacionales en 2020 según AEMET.
- Datos de variación de defunciones por comunidad autónoma en formato JSON: aumento de defunciones en 2020 respecto a 2019, procedente del INE a través de epdata.
- Datos de muertes atribuidas a COVID-19 en formato CSV: muertes por COVID-10 con virus identificado en 2020 por comunidad autónoma, del INE.
- Datos de población por comunidad autónoma en formato PC-Axis: población de 2020, del INE.

Las fuentes se importan, limpian y homogeneizan en R para utilizar nombres comunes de comunidades autónomas. Las olas de calor, que vienen por provincia, se agrupan por comunidad
calculando la media de días de ola por provincia. Posteriormente, se integran mediante operaciones de unión todas las fuentes y se calcula la variación de defunciones no atribuida 
a COVID-19 por cada 100.000 habitantes.

El análisis permite detectar asociaciones y patrones territoriales, pero no establecer una relación causal entre las olas de calor y las defunciones.

# 3. ESTRUCTURA DEL REPOSITORIO

Para mantener el orden en nuestro trabajo, hemos organizado los archivos en distintas carpetas y documentos:

- **Seminario_Fuentes.Rmd**: documento principal en R Markdown. Contiene todo el trabajo: introducción, objetivos, metodología (importación, limpieza y unión de los datos), 
gráficos y su análisis correspondiente. 


- **Seminario_Fuentes.html**: resultado al ejecutar (knit) el .Rmd. Es la versión final para leer en el navegador.


- **INPUT/DATA**: datos originales, sin modificar.
  - `olas_calor_provincias_2020.json`
  - `muertes_comunidad_autonoma_2020.json`
  - `49923.csv`: defunciones por COVID-19 por ccaa.
  - `poblacion.px`: población por ccaa
  - `muertes_semana.json`
  - `muertesCovidSemana.csv`
  - `defunciones_semana_2020_2019.json`
  
-**INPUT/IMAGENES**:
  - `fondo_seminario.png`
  - `wordcloud.png`

- **SALIDA**: gráficos exportados en formato PNG, para consultarlos sin ejecutar el código



- **Scripts**:borradores de los gráficos, que cada miembro del grupo desarrolló antes de integrarlos en el `.Rmd`.
  - `01_Analisis_Olas_Calor`: exposición al calor (días de ola por comunidad y olas por provincia).
  - `02_Mortalidad-y_Impacto_Covid`: aumento de defunciones y peso del COVID-19.
  - `03_Interaccion_Calor_Mortalidad`: relacion entre las olas de calor y las defunciones no atribuidas al COVID-19.


# 4. RESULTADOS

En 2020 hubo tres olas de calor en España. Castilla y León, Castilla-La Mancha y Andalucía aparecen en las tres. Asturias, Cantabria, Canarias, Extremadura, La Rioja, Ceuta y Melilla no aparecen en ninguna.

Murió más gente que en 2019 en todas las comunidades (entre 47 y 345 más por cada 100.000 habitantes). La mayor parte se debe al COVID-19, pero en casi todas las comunidades quedan muertes de más que el COVID-19 no explica.

Mirando el año entero, la relación entre los días de ola de calor y esas muertes de más es muy débil.

Si miramos semana a semana en verano, en Castilla-La Mancha, Madrid, Cataluña y Castilla y León las muertes extra suben justo cuando llega la ola de calor de finales de julio. Pero también hay subidas parecidas en comunidades sin olas.

**Conclusión:** Nuestros datos son compatibles con que las olas de calor contribuyeran a las muertes extra de 2020, pero no lo podemos confirmar ni descartar. Hay que tener en cuenta que los días de ola son una aproximación, que solo comparamos con 2019, que parte de las muertes "no COVID" pueden ser COVID-19 sin diagnosticar y que trabajamos con solo 19 comunidades.


# 5.INSTRUCCIONES DE EJECUCIÓN
Para reproducir este seminario en tu equipo debes seguir los siguientes pasos:

1. **Clonar el repositorio**:
  ```bash
  git clone https://github.com/SergioPascualRedondo/Seminario_Fuentes_I`
  ```
  
2. **Instalar las dependencias**:
``` r
install.packages(c("tidyverse","jsonlite","tidyjson","pxR","mapSpain","plotly"))`
```
3. **Generar el informe**: abre `Seminario_Fuentes.Rmd` en RStudio y pulsa **knit**. 
Se generará `Seminario_Fuentes.html`.

# 6. REFERENCIAS Y RECURSOS
**Fuentes de Datos**: 
- INE: Instituto Nacional de Estadística
- EpData: plataforma de análisis y visualización de datos de Europa Press. 
