#Forma-04

#LIBRERÍAS
if (!require(ggpubr) ) {
  install.packages("ggpubr", dependencies = TRUE )
  require (ggpubr)
}
if (!require(tidyverse) ) {
  install.packages("tidyverse", dependencies = TRUE )
  require (tidyverse)
}
if (!require(dplyr) ) {
  install.packages("dplyr", dependencies = TRUE )
  require (dplyr)
}
if (!require(ez) ) {
  install.packages("ez", dependencies = TRUE )
  require (ez)
}
if (!require(emmeans) ) {
  install.packages("emmeans", dependencies = TRUE )
  require (emmeans)
}
if (!require(nlme) ) {
  install.packages("nlme", dependencies = TRUE )
  require (nlme)
}
if (!require(corrplot)){
  install.packages("corrplot", dependencies = TRUE )
  require (corrplot)
}
if (!require(caret)){
  install.packages("caret", dependencies = TRUE )
  require (caret)
}
if (!require(pROC)){
  install.packages("pROC", dependencies = TRUE )
  require (pROC)
}

# Se obtienen los datos del ejercicio
datos <- read.csv(file.choose(), head = TRUE, sep=";", encoding = "UTF-8")

#PREGUNTA 1


#PREGUNTA 2

#PREGUNTA 3

# Proponga un ejemplo novedoso (no mencionado en clase ni que aparezca en las 
#lecturas dadas) en donde un estudio o experimento, relacionado con las
#expectativas de los chilenos para el nuevo gobierno, necesite utilizar una 
#prueba de los rangos con signo de Wilcoxon debido a problemas con la escala de
#la variable dependiente en estudio.
#Indiqué cuáles serían las variables involucradas en su ejemplo (con sus 
#respectivos niveles) y las hipótesis nula y alternativa a contrastar.


#Se realiza una encuesta a personas que viven en 2 grupos distintos de comunas.
#Estos dos grupos son: comunas del barrio bajo y comunas del barrio alto.
#En esta encuesta se busca evaluar las propuestas mas relevantes del plan del
#nuevo gobierno, con notas del 1 al 7 para cada propuesta, calculando el
#promedio simple entre estas notas. La valoracion final por cada persona
#corresponde a este promedio.


#Variables: Valoracion del nuevo plan de gobierno (promedio de calificacion
#de propuestas). Esta es una variable ordinal.

#HIPÓTESIS
#H0: No hay diferencias en la valoracion al plan de gobierno (mismas distribuciones)
#HA: Hay diferencias en la valoracion al plan de gobierno (distintas distribuciones)