# CALOR, COVID Y MORTALIDAD EN ESPAÑA EN 2020

**Autores**: Laura Lasierra Gastón, Ángela Navarro Cantón y Sergio Pascual Redondo

**Curso Académico**: 2026/2027

**Grupo**: I

**Asignatura**: Fuentes de Datos Biomédicos y Web Semántica

---

# 1. INTRODUCCIÓN

En este seminario se va a llevar a cabo una comprobación estadística de la relación entre las altas temperaturas, el covid y el aumento de la mortalidad en España en 2020.
En ese año, España vivió a la misma vez la primera y más grande oleada de casos de COVID-19 y un verano con varias olas de calor. Se sabe que el calor extremo lleva consigo
un aumento de la mortalidad, y que el COVID-19 provocó un incremento muy marcado de muertes con respecto a 2019, pero ambos fenómenos se solapan en el mismo año y puede ser 
complicado en algunos casos separar su efecto. No está claro si, una vez descontadas las muertes provocadas por el COVID-19, el aumento de defunciones que queda por comunidad
autónoma en 2020 con respecto a 2019 guarda relación con la exposición a olas de calor.


Vamos a estudiar esta cuestión con fuentes oficiales (AEMET e INE), utilizando R y datos en formato JSON y CSV.

# 2. OBJETIVOS

## OBJETIVO GENERAL

Analizar si el aumento de muertes en 2020 respecto a 2019 en las comunidades autónomas españolas se relaciona con las olas de calor, teniendo en cuenta las muertes por COVID-19.

## OBJETIVOS ESPECÍFICOS

1. ¿Cuántas olas de calor y cuántos días de ola se registraron en 2020 en cada provincia y CCAA?
2. ¿En qué comunidades aumentaron más las defunciones en 2020 respecto a 2019?
3. ¿Qué parte de ese aumento corresponden a muertes por COVID-19?
4. ¿Están relacionadas las olas de calor y el aumento de muertes con el COVID-19?
## Metodología

Se realiza un estudio descriptivo y exploratorio utilizando información
agregada por provincia y comunidad autónoma. Los datos proceden de cuatro
fuentes y se encuentran en diferentes formatos:

- Datos de olas de calor por provincia en formato JSON.
- Datos de variación de defunciones por comunidad autónoma en formato JSON.
- Datos de muertes atribuidas a COVID-19 en formato CSV.
- Datos de población por comunidad autónoma en formato PC-Axis.

Las fuentes se importan, limpian y homogeneizan para utilizar nombres
comunes de comunidades autónomas. Posteriormente, se integran mediante
operaciones de unión y se calcula la variación de defunciones no atribuida
a COVID-19 por cada 100.000 habitantes.

El análisis permite detectar asociaciones y patrones territoriales, pero
no establecer una relación causal entre las olas de calor y las
defunciones.

# 3. ESTRUCTURA DEL REPOSITORIO




# 4. RESULTADOS






# 5.INSTRUCCIONES DE EJECUCIÓN





# 6. REFERENCIAS Y RECURSOS