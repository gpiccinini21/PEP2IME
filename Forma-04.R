#Forma-04

#LIBRERíAS
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

# Hipótesis a contrastar:
# H0: No existen diferencias significativas en el promedio de la evaluación realizada por el general entre las distintas divisiones
# HA: Existen diferencias significativas en el promedio de la evaluación realizada por el general entre las distintas divisiones

Cavetrooper <- filter(datos, division == 'Cavetrooper')
Snowtrooper <- filter(datos, division == 'Snowtrooper')
Lavatrooper <- filter(datos, division == 'Lavatrooper')
Shoretrooper <- filter(datos, division == 'Shoretrooper')
Spacetrooper <- filter(datos, division == 'Spacetrooper')
Sandtrooper <- filter(datos, division == 'Sandtrooper')
Flametrooper <- filter(datos, division == 'Flametrooper')
Recontrooper <- filter(datos, division == 'Recontrooper')

instancia <- factor(1:nrow(Cavetrooper))

Cavetrooper <- as.double(gsub(",", ".", Cavetrooper$eval_general))
Snowtrooper <- as.double(gsub(",", ".", Snowtrooper$eval_general))
Lavatrooper <- as.double(gsub(",", ".", Lavatrooper$eval_general))
Shoretrooper <- as.double(gsub(",", ".", Shoretrooper$eval_general))
Spacetrooper <- as.double(gsub(",", ".", Spacetrooper$eval_general))
Sandtrooper <- as.double(gsub(",", ".", Sandtrooper$eval_general))
Flametrooper <- as.double(gsub(",", ".", Flametrooper$eval_general))
Recontrooper <- as.double(gsub(",", ".", Recontrooper$eval_general))


datos_evaluacion <- data.frame(instancia, Cavetrooper, Snowtrooper, Lavatrooper, Shoretrooper, Spacetrooper, Sandtrooper, Flametrooper, Recontrooper)

#Llevar data frame a formato largo .
datos_evaluacion <- datos_evaluacion %>% pivot_longer(c("Cavetrooper", "Snowtrooper", "Lavatrooper", "Shoretrooper", "Spacetrooper", "Sandtrooper", "Flametrooper", "Recontrooper"),
                                                      names_to = "division", values_to = "evaluacion")

datos_evaluacion[["division"]] <- factor(datos_evaluacion[["division"]])

# Se utiliza la prueba de anova con muestras correlacionadas, puesto que el que evalúa es el mismo instructor para cada uno
# de los reclutas de las distintas divisiones.
# Se verifican las condiciones para utilizar ANOVA:
# - Se puede suponer que las muestras son obtenidas de manera aleatoria e independiente.
# - La escala con la que se mide la evaluación del general tiene las propiedades de una escala de intervalos iguales.
# - Se utiliza la función de R ezANOVA() que incluye una prueba para verificar la condición de: 
#   la prueba de esfericidad de Mauchly.
# - Se puede suponer razonablemente que la población de origen sigue una distribución
#   normal, la cual se puede observar por medio del gráfico Q-Q, se debe tener en cuenta
#   que casi no existen valores que pueden ser atípicos, por lo que se utiliza un nivel de significación 
#   bastante más exigente, igual a alfa = 0,05.


# Nivel de significación.
alfa <- 0.05

# Comprobación de normalidad .
g <- ggqqplot(datos_evaluacion , x = "evaluacion", y = "division", color = "division")
g <- g + facet_wrap(~ division )
g <- g + rremove("x.ticks") + rremove("x.text")
g <- g + rremove("y.ticks") + rremove("y.text")
g <- g + rremove("axis.title")
print(g)


prueba <- ezANOVA(data = datos_evaluacion, dv = evaluacion, within = division,
                  wid = instancia , return_aov = TRUE )

print(summary(prueba$aov))

cat("Resultado de la prueba de esfericidad de Mauchly :\n\n")
print(prueba[["Mauchly's Test for Sphericity"]])

# El valor p obtenido en esta prueba es mayor al nivel de significancia de 0.05,
# con un valor de p = 0.1117474 de lo que se desprende que los datos  si cumplen
# con la condición de esfericidad (hipótesis nula de la prueba de Mauchly).


# Conclusión de prueba ANOVA:
# Con respecto al resultado obtenido y al obtener un p = <2e-16, inferior al
# nivel de significación, se rechaza la hipótesis nula a favor de la alternativa, por lo tanto,
# se concluye con un 95% de confianza que existen diferencias significativas en el promedio de 
# la evaluación realizada por el general entre las distintas divisiones.  

# Procedimiento post-hoc HSD de Tukey.

mixto <- lme(evaluacion ~ division , data = datos_evaluacion , random = ~1|instancia )
medias <- emmeans(mixto , "division")
tukey <- pairs ( medias , adjust = "tukey")

cat("\n\nPrueba HSD de Tukey\n\n")
print(tukey)

# Conclusión post-hoc
# Se utiliza esta prueba para buscar las diferencias significativas
# Con un nivel de significancia de 0.05 los pares de divisiones con diferencias
# significativas son:

# contrast                    estimate    SE  df t.ratio p.value
# Cavetrooper - Recontrooper    9.1597 0.697 693  13.145  <.0001
# Cavetrooper - Shoretrooper   -9.8296 0.697 693 -14.107  <.0001
# Flametrooper - Recontrooper  10.1714 0.697 693  14.597  <.0001
# Flametrooper - Shoretrooper  -8.8179 0.697 693 -12.655  <.0001
# Lavatrooper - Recontrooper    8.5408 0.697 693  12.257  <.0001
# Lavatrooper - Shoretrooper  -10.4485 0.697 693 -14.995  <.0001
# Recontrooper - Sandtrooper   -9.2941 0.697 693 -13.338  <.0001
# Recontrooper - Shoretrooper -18.9893 0.697 693 -27.252  <.0001
# Recontrooper - Snowtrooper   -9.4907 0.697 693 -13.620  <.0001
# Recontrooper - Spacetrooper  -9.5782 0.697 693 -13.746  <.0001
# Sandtrooper - Shoretrooper   -9.6952 0.697 693 -13.914  <.0001
# Shoretrooper - Snowtrooper    9.4986 0.697 693  13.632  <.0001
# Shoretrooper - Spacetrooper   9.4111 0.697 693  13.506  <.0001


#PREGUNTA 2

datos2 <- datos
set.seed(892)
# Muestra de 400 datos
datos2<- datos2[sample(nrow(datos2), 400),]

# Separar conjuntos de entrenamiento y prueba.
n <- nrow(datos2)
n_entrenamiento <- floor(0.8 * n)
muestra <- sample.int(n = n , size = n_entrenamiento, replace = FALSE )
entrenamiento <- datos2[muestra, ]
prueba <- datos2[-muestra , ]

# Ajustar modelo nulo .
nulo <- glm(as.factor(datos2$es_clon) ~ 1, family = binomial(link = "logit"), data = entrenamiento)

# Ajustar modelo completo .
cat ("\n\n")
# completo <- glm(as.factor(datos2$es_clon) ~ ., family = binomial(link ="logit"), data = entrenamiento)


#PREGUNTA 3

# Proponga un ejemplo novedoso (no mencionado en clase ni que aparezca en las 
#lecturas dadas) en donde un estudio o experimento, relacionado con las
#expectativas de los chilenos para el nuevo gobierno, necesite utilizar una 
#prueba de los rangos con signo de Wilcoxon debido a problemas con la escala de
#la variable dependiente en estudio.
#Indique cuáles serían las variables involucradas en su ejemplo (con sus 
#respectivos niveles) y las hipótesis nula y alternativa a contrastar.


#Se realiza una encuesta a personas que viven en 2 grupos distintos de comunas.
#Estos dos grupos son: comunas del barrio bajo y comunas del barrio alto.
#En esta encuesta se busca evaluar las propuestas mas relevantes del plan del
#nuevo gobierno, con notas del 1 al 7 para cada propuesta, calculando el
#promedio simple entre estas notas. La valoración final por cada persona
#corresponde a este promedio.


#Variables: Valoración del nuevo plan de gobierno (promedio de calificación
#de propuestas). Esta es una variable ordinal.

#HIPÓTESIS
#H0: No hay diferencias en la valoración al plan de gobierno (mismas distribuciones)
#HA: Hay diferencias en la valoración al plan de gobierno (distintas distribuciones)