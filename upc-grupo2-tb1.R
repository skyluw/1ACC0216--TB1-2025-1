#Eliminamos cualquier informacion previa
rm(list=ls(all=TRUE))
graphics.off()
cat("\014")

#install.packages("lubridate")
#install.packages("VIM",dependencies=TRUE) 
install.packages("zoo")
install.packages("dplyr")
#Agregamos las librerias necesarias
library(DescTools)
library(mlr)
library(ggplot2)
library(agricolae)
library(cowplot)
library(patchwork)
library(lattice)
library(lubridate)
library(plotly)
library(VIM) 
library(zoo)
library(dplyr)

#Ubicamos la carpeta de trabajo
setwd("C:/Users/Alejandro/Desktop/UPC/DataScience/TB1")

#Leemos el csv
data_hotel <- read.table('hotel_bookings.csv', header=TRUE, sep=',',dec='.', stringsAsFactors = FALSE)

#Analizamos la estructura general del dataset
str(data_hotel)

#Vista de las primeras filas
head(data_hotel)

#Reemplazamos los valores NULL por NA
data_hotel[data_hotel == "NULL"] <- NA

#Conversión de columnas y corrección de tipos de dato
data_hotel$hotel <- as.factor(data_hotel$hotel)
data_hotel$arrival_date_month <- factor(data_hotel$arrival_date_month, levels = month.name)
data_hotel$reservation_status <- as.factor(data_hotel$reservation_status)
data_hotel$meal <- as.factor(data_hotel$meal)
data_hotel$customer_type <- as.factor(data_hotel$customer_type)
data_hotel$deposit_type <- as.factor(data_hotel$deposit_type)
data_hotel$country <- as.factor(data_hotel$country)
data_hotel$reservation_status_date <- ymd(data_hotel$reservation_status_date)


#Añadimos nuevas variables
#Total de noches
data_hotel$total_nights <- data_hotel$stays_in_weekend_nights + data_hotel$stays_in_week_nights

#Variable booleana que determina si hay niños
data_hotel$has_kids <- ifelse(data_hotel$children > 0 | data_hotel$babies > 0, 1, 0)

#Resumen del dataset
summary(data_hotel)

#Controlamos la proporción de datos faltantes
aggr(data_hotel,numbers=T,sortVar=T) 

#Eliminamos la columna company porque posee un alto porcentaje de 
#datos faltantes y no aportará al análisis
data_hotel$company <- NULL

#Imputamos los datos faltantes de agent con el valor aleatorio Desconocido
data_hotel$agent[is.na(data_hotel$agent)] <- "Desconocido"

#Imputamos los datos faltantes del dataset con la moda de country
#Primero calculamos la moda de country
data_hotel$country <- as.factor(data_hotel$country)
moda_country <- names(which.max(table(data_hotel$country)))
data_hotel$country[is.na(data_hotel$country)] <- moda_country

#Imputamos los datos faltantes de children con la mediana
data_hotel$children[is.na(data_hotel$children)] <- median(data_hotel$children, na.rm = TRUE)

#Hacemos lo mismo con has_kids
data_hotel$has_kids[is.na(data_hotel$has_kids)] <- median(data_hotel$has_kids, na.rm = TRUE)

#Verificamos nuevamente con summary
summary(data_hotel)

#Verificamos los datos con posibles valores atípicos
summary(data_hotel$adr)
summary(data_hotel$lead_time)
summary(data_hotel$total_nights)
summary(data_hotel$adults)
summary(data_hotel$children)
summary(data_hotel$babies)
summary(data_hotel$booking_changes)
summary(data_hotel$days_in_waiting_list)
summary(data_hotel$required_car_parking_spaces)

#Procedemos a analizar cada una de dichas variables

#Adr

#Verificamos boxplot para la variable adr
p2 <- ggplot(data_hotel, aes(x = "", y = adr)) +
  geom_boxplot(fill = "steelblue") +
  labs(title = "Boxplot de ADR", y = "adr") +
  theme_classic()
p2

#Identificamos los outliers con rango intercuartílico
# Calcular IQR y límites para 'adr'
Q1 <- quantile(data_hotel$adr, 0.25, na.rm = TRUE)
Q3 <- quantile(data_hotel$adr, 0.75, na.rm = TRUE)
IQR <- Q3 - Q1

# Límites para detectar outliers
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

# Extraer valores que son outliers
outliers_iqr <- data_hotel$adr[data_hotel$adr < lower_bound | data_hotel$adr > upper_bound]
outliers_iqr

#Aplicamos winsorización
# Definir límites del 1% y 99% para 'adr'
lower_bound <- quantile(data_hotel$adr, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$adr, 0.99, na.rm = TRUE)

# Crear variable winsorizada 
data_hotel$adr_capped <- ifelse(data_hotel$adr < lower_bound, lower_bound,
                                ifelse(data_hotel$adr > upper_bound, upper_bound,
                                       data_hotel$adr))

# Comparamos visualmente con boxplots
par(mfrow = c(1, 2))
boxplot(data_hotel$adr, main = "ADR con outliers", col = "skyblue")
boxplot(data_hotel$adr_capped, main = "ADR sin outliers (wins)", col = "salmon")


#lead_time

#Verificamos el boxplot de la variable lead_time
p3 <- ggplot(data_hotel, aes(y = "", x = lead_time)) +
  geom_boxplot(fill = "steelblue") +
  labs(title = "Boxplot de lead_time", x = "lead_time") +
  theme_classic()
p3

#Extraemos los outliers del boxplot
lead_time_outliers <- boxplot(data_hotel$lead_time,plot=FALSE)$out
lead_time_outliers

# Calculamos límites del 1% y 99%
lower_bound <- quantile(data_hotel$lead_time, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$lead_time, 0.99, na.rm = TRUE)

# Calculamos la mediana de lead_time
lead_time_median <- median(data_hotel$lead_time, na.rm = TRUE)

# Imputamos outliers con la mediana
data_hotel$lead_time_imputed <- ifelse(data_hotel$lead_time < lower_bound |
                                         data_hotel$lead_time > upper_bound,
                                       lead_time_median,
                                       data_hotel$lead_time)

# Comparamos visualmente con boxplots
par(mfrow = c(1, 2))
boxplot(data_hotel$lead_time, main = "Lead Time con outliers", col = 5)
boxplot(data_hotel$lead_time_imputed, main = "Lead Time sin outliers (mediana)", col = 6)

#total_nights

#Verificamos boxplot para la variable total_nights
p4<-ggplot(data_hotel, aes(x =total_nights)) + 
  geom_boxplot(fill="steelblue") + 
  labs(title = "Boxplot de total_nights", 
  )+ 
  theme_classic() 
p4

#Extraemos los outliers
total_nights_outliers <- boxplot(data_hotel$total_nights,plot=FALSE)$out
total_nights_outliers

#Calculamos límites del 1% y 99%
lower_bound <- quantile(data_hotel$total_nights, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$total_nights, 0.99, na.rm = TRUE)

#Calculamos la mediana
total_nights_median <- median(data_hotel$total_nights, na.rm = TRUE)

#Imputamos outliers con la mediana
data_hotel$total_nights_imputed <- ifelse(data_hotel$total_nights < lower_bound |
                                            data_hotel$total_nights > upper_bound,
                                          total_nights_median,
                                          data_hotel$total_nights)

#Visualizamos la comparación
par(mfrow = c(1, 2))
boxplot(data_hotel$total_nights, main = "Total Nights con outliers", col = "orchid")
boxplot(data_hotel$total_nights_imputed, main = "Total Nights sin outliers (mediana)", col = "palegreen3")

#adults

#Verificamos boxplot para la variable adults
p5<-ggplot(data_hotel, aes(x =adults)) + 
  geom_boxplot(fill="steelblue") + 
  labs(title = "Boxplot de adults", 
  )+ 
  theme_classic() 
p5

#Extraemos los outliers
adults_outliers <- boxplot(data_hotel$adults,plot=FALSE)$out
adults_outliers

# Calculamos límites del 1% y 99%
lower_bound <- quantile(data_hotel$adults, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$adults, 0.99, na.rm = TRUE)

# Calculamos la mediana
adults_median <- median(data_hotel$adults, na.rm = TRUE)

# Imputamos outliers con la mediana
data_hotel$adults_imputed <- ifelse(data_hotel$adults < lower_bound |
                                      data_hotel$adults > upper_bound,
                                    adults_median,
                                    data_hotel$adults)

# Visualizamos la comparación
par(mfrow = c(1, 2))
boxplot(data_hotel$adults, main = "Adults con outliers", col = "orange")
boxplot(data_hotel$adults_imputed, main = "Adults sin outliers (mediana)", col = "lightblue")


#children

#Verificamos boxplot para la variable children
p6<-ggplot(data_hotel, aes(x =children)) + 
  geom_boxplot(fill="steelblue") + 
  labs(title = "Boxplot de children", 
  )+ 
  theme_classic() 
p6

#Extraemos los outliers
children_outliers <- boxplot(data_hotel$children,plot=FALSE)$out
children_outliers

#Aplicamos winsorización
# Definir límites del 1% y 99% para 'children'
lower_bound <- quantile(data_hotel$children, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$children, 0.99, na.rm = TRUE)

# Crear variable winsorizada
data_hotel$children_capped <- ifelse(data_hotel$children < lower_bound, lower_bound,
                                     ifelse(data_hotel$children > upper_bound, upper_bound,
                                            data_hotel$children))

# Comparar visualmente con boxplots
par(mfrow = c(1, 2))
boxplot(data_hotel$children, main = "Children con outliers", col = "gold")
boxplot(data_hotel$children_capped, main = "Children sin outliers (wins)", col = "darkolivegreen3")


#babies

#Verificamos boxplot para la variable babies
p7<-ggplot(data_hotel, aes(x =babies)) + 
  geom_boxplot(fill="steelblue") + 
  labs(title = "Boxplot de babies", 
  )+ 
  theme_classic() 
p7

#Extraemos los outliers
babies_outliers <- boxplot(data_hotel$babies,plot=FALSE)$out
babies_outliers

#Aplicamos winsorización
# Definir límites del 1% y 99% para 'babies'
lower_bound <- quantile(data_hotel$babies, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$babies, 0.99, na.rm = TRUE)

# Crear variable winsorizada
data_hotel$babies_capped <- ifelse(data_hotel$babies < lower_bound, lower_bound,
                                   ifelse(data_hotel$babies > upper_bound, upper_bound,
                                          data_hotel$babies))

# Comparar visualmente con boxplots
par(mfrow = c(1, 2))
boxplot(data_hotel$babies, main = "Babies con outliers", col = "lightcoral")
boxplot(data_hotel$babies_capped, main = "Babies sin outliers (wins)", col = "mediumseagreen")

#booking_changes

#Verificamos boxplot para la variable booking_changes
p8<-ggplot(data_hotel, aes(x =booking_changes)) + 
  geom_boxplot(fill="steelblue") + 
  labs(title = "Boxplot de booking_changes", 
  )+ 
  theme_classic() 
p8

#Extraemos los outliers
booking_changes_outliers <- boxplot(data_hotel$booking_changes,plot=FALSE)$out
booking_changes_outliers

# Calculamos límites del 1% y 99%
lower_bound <- quantile(data_hotel$booking_changes, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$booking_changes, 0.99, na.rm = TRUE)

# Calculamos la mediana
booking_changes_median <- median(data_hotel$booking_changes, na.rm = TRUE)

# Imputamos outliers con la mediana
data_hotel$booking_changes_imputed <- ifelse(data_hotel$booking_changes < lower_bound |
                                               data_hotel$booking_changes > upper_bound,
                                             booking_changes_median,
                                             data_hotel$booking_changes)

# Visualizamos la comparación
par(mfrow = c(1, 2))
boxplot(data_hotel$booking_changes, main = "Booking Changes con outliers", col = "darkorange2")
boxplot(data_hotel$booking_changes_imputed, main = "Booking Changes sin outliers (mediana)", col = "aquamarine3")

#days_in_waiting_list
# Verificamos boxplot para la variable days_in_waiting_list
p9 <- ggplot(data_hotel, aes(x = days_in_waiting_list)) + 
  geom_boxplot(fill = "steelblue") + 
  labs(title = "Boxplot de days_in_waiting_list") + 
  theme_classic()

p9

# Extraemos los outliers
days_in_waiting_list_outliers <- boxplot(data_hotel$days_in_waiting_list, plot = FALSE)$out
days_in_waiting_list_outliers

# Calculamos límites del 1% y 99%
lower_bound <- quantile(data_hotel$days_in_waiting_list, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$days_in_waiting_list, 0.99, na.rm = TRUE)

# Calculamos la mediana
waiting_list_median <- median(data_hotel$days_in_waiting_list, na.rm = TRUE)

# Imputamos outliers con la mediana
data_hotel$days_in_waiting_list_imputed <- ifelse(data_hotel$days_in_waiting_list < lower_bound |
                                                    data_hotel$days_in_waiting_list > upper_bound,
                                                  waiting_list_median,
                                                  data_hotel$days_in_waiting_list)

# Visualizamos la comparación
par(mfrow = c(1, 2))
boxplot(data_hotel$days_in_waiting_list, main = "Days in Waiting List con outliers", col = "violetred3")
boxplot(data_hotel$days_in_waiting_list_imputed, main = "Days in Waiting List sin outliers (mediana)", col = "palegreen4")

#required_car_parking_spaces
# Verificamos boxplot para la variable required_car_parking_spaces
p10 <- ggplot(data_hotel, aes(x = required_car_parking_spaces)) + 
  geom_boxplot(fill = "steelblue") + 
  labs(title = "Boxplot de required_car_parking_spaces") + 
  theme_classic()

p10

# Extraemos los outliers
required_car_parking_spaces_outliers <- boxplot(data_hotel$required_car_parking_spaces, plot = FALSE)$out
required_car_parking_spaces_outliers

#Aplicamos winsorización
# Definir límites del 1% y 99% para 'required_car_parking_spaces'
lower_bound <- quantile(data_hotel$required_car_parking_spaces, 0.01, na.rm = TRUE)
upper_bound <- quantile(data_hotel$required_car_parking_spaces, 0.99, na.rm = TRUE)

# Crear variable winsorizada
data_hotel$car_parking_spaces_capped <- ifelse(data_hotel$required_car_parking_spaces < lower_bound, lower_bound,
                                               ifelse(data_hotel$required_car_parking_spaces > upper_bound, upper_bound,
                                                      data_hotel$required_car_parking_spaces))

# Comparar visualmente con boxplots
par(mfrow = c(1, 2))
boxplot(data_hotel$required_car_parking_spaces, main = "Parking Spaces con outliers", col = "lightcoral")
boxplot(data_hotel$car_parking_spaces_capped, main = "Parking Spaces sin outliers (wins)", col = "mediumseagreen")

#Guardamos el dataset limpio
write.csv(data_hotel, file = "data_hotel_limpio.csv", row.names = FALSE)

#REALIZAMOS EL ANÁLISIS DE DATOS

#¿Cuántas reservas se realizan por tipo de hotel? ¿Qué tipo de hotel prefiere la gente?

# Leer datos limpios
hotel_datos <- read.csv("data_hotel_limpio.csv", stringsAsFactors = TRUE)

# Visualización: número de reservas por tipo de hotel
p1 <- ggplot(hotel_datos, aes(x = hotel, fill = hotel)) +
  geom_bar() +
  labs(title = "Reservas por tipo de hotel", x = "Tipo de Hotel", y = "Cantidad de Reservas") +
  theme_minimal()

p1
table(hotel_datos$hotel)

#¿Está aumentando la demanda con el tiempo?

# Crear columna de año-mes para agrupar
hotel_datos$anio_mes <- as.yearmon(data_hotel$reservation_status_date)

# Visualización: tendencia de reservas en el tiempo
p2 <- ggplot(hotel_datos, aes(x = anio_mes)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Tendencia de reservas en el tiempo",
       x = "Año y mes",
       y = "Cantidad de reservas") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

p2

#¿Cuáles son las temporadas de reservas (alta, media, baja)? 
tabla_reservas_mes <- table(hotel_datos$arrival_date_month)
print(tabla_reservas_mes)

p1 <- ggplot(hotel_datos, aes(x = arrival_date_month, fill = arrival_date_month)) + 
  geom_bar() +
  labs(title = "Reservas por mes", x = "Mes de llegada", y = "Cantidad de reservas") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(p1)

#¿Cuál es la duración promedio de las estancias por tipo de hotel?

duracion_promedio <- tapply(hotel_datos$total_nights_imputed,
                            hotel_datos$hotel,
                            mean, na.rm = TRUE)
print(duracion_promedio)

# Gráfico de barras de duración promedio por tipo de hotel
p2 <- ggplot(hotel_datos, aes(x = hotel, y = total_nights_imputed, fill = hotel)) +
  stat_summary(fun = mean, geom = "bar") +
  labs(title = "Duración promedio de estancia por tipo de hotel",
       x = "Tipo de hotel", y = "Noches (promedio)") +
  theme_minimal()
print(p2)

#¿Cuántas reservas incluyen niños y/o bebés?
cantidad_con_menores <- sum(hotel_datos$children_capped > 0 | hotel_datos$babies_capped > 0)
print(cantidad_con_menores)

hotel_datos$tiene_menores <- ifelse(hotel_datos$children_capped > 0 | hotel_datos$babies_capped > 0,"Sí", "No")

p3 <- ggplot(hotel_datos, aes(x = tiene_menores, fill = tiene_menores)) +
  geom_bar() +
  labs(title = "Reservas con niños y/o bebés", x = "Incluye menores", y = "Cantidad de reservas") +
  theme_minimal()

print(p3)


#¿Es importante contar con espacios de estacionamiento?

hotel_datos %>%
  group_by(required_car_parking_spaces, is_canceled) %>%
  summarize(count = n()) %>%
  ggplot(aes(x = factor(required_car_parking_spaces), y = count, fill = factor(is_canceled))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Reservas canceladas vs no canceladas según estacionamiento requerido",
    x = "Espacios de estacionamiento requeridos",
    y = "Cantidad de reservas",
    fill = "¿Cancelada?"
  ) +
  theme_minimal()

#¿En qué meses del año se producen más cancelaciones de reservas? 

cancelaciones_por_mes <- hotel_datos %>%
  filter(is_canceled == 1) %>%
  group_by(arrival_date_month) %>%
  summarize(cantidad_cancelaciones = n())
cancelaciones_por_mes$arrival_date_month <- factor(
  cancelaciones_por_mes$arrival_date_month,
  levels = c("January", "February", "March", "April", "May", "June",
             "July", "August", "September", "October", "November","December")
)

ggplot(cancelaciones_por_mes, aes(x = arrival_date_month, y = cantidad_cancelaciones)) +
  geom_bar(stat = "identity", fill = "tomato") +
  labs(
    title = "Cancelaciones de reservas por mes",
    x = "Mes de llegada",
    y = "Cantidad de cancelaciones"
  ) +
  theme_minimal()
  
#¿Existe una relación entre el tipo de cliente (por ejemplo, cliente recurrente vs. nuevo) y la probabilidad de cancelar una reserva?

hotel_datos %>%
  group_by(is_repeated_guest, is_canceled) %>%
  summarize(cantidad = n()) %>%
  mutate(tipo_cliente = ifelse(is_repeated_guest == 1, "Recurrente", "Nuevo"),
         estado = ifelse(is_canceled == 1, "Cancelado", "No cancelado"))

hotel_datos %>%
  group_by(is_repeated_guest, is_canceled) %>%
  summarize(cantidad = n()) %>%
  mutate(tipo_cliente = ifelse(is_repeated_guest == 1, "Recurrente", "Nuevo"),
         estado = ifelse(is_canceled == 1, "Cancelado", "No cancelado")) %>%
  ggplot(aes(x = tipo_cliente, y = cantidad, fill = estado)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Cancelaciones según tipo de cliente",
    x = "Tipo de cliente",
    y = "Cantidad de reservas",
    fill = "Estado de reserva"
  ) +
  theme_minimal()