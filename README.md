# 1ACC0216-TB1-2025-1: Análisis de Demanda de Reservas Hoteleras
## 🎯 Objetivo del Trabajo
Realizar un análisis exploratorio de datos (EDA) sobre el conjunto de datos "Hotel booking demand" para identificar patrones de comportamiento, generar visualizaciones, preparar los datos y extraer conclusiones iniciales utilizando RStudio como herramienta.
---

## 👥 Participantes

- Cielo Luwidka Chavez Merino 
- Marco Antonio Luciano Cabrera Díaz
- Carlos Alejandro Colfer Mendoza

---
## 📊 Descripción del Dataset

El conjunto de datos **Hotel booking demand** contiene información sobre reservas hoteleras para dos tipos de hoteles:

- 🏙️ *City Hotel*
- 🏖️ *Resort Hotel*

Incluye detalles como:

- Fechas de reserva y llegada  
- Duración de la estancia  
- Número de personas (adultos, niños, bebés)  
- Tipos de comidas incluidas  
- País de origen de los huéspedes  
- Canales de distribución y segmentos de mercado  
- Tipos de habitaciones reservadas y asignadas  
- Información sobre cancelaciones  
- Solicitudes especiales y necesidades de estacionamiento  
- Tarifa diaria promedio (ADR)

> ⚠️ El dataset ha sido modificado intencionalmente con **datos faltantes (NA)** y **valores atípicos (outliers)** como parte del ejercicio académico.

---

## 📁 Estructura del Repositorio
📦 proyecto/
├── data/
│ ├── hotel_bookings.csv # Dataset original
│ └── hotel_data_processed.csv # Dataset limpio y transformado
│
├── code/
│ ├── analysis.R # Script principal con el EDA
│ ├── visualizations.R # Funciones de visualización
│ └── data_cleaning.R # Limpieza y preprocesamiento
│
└── README.md

---

## 🔍 Principales Conclusiones

- **Preferencia por tipo de hotel:** La gente prefiere ampliamente City Hotel por sobre Resort Hotel 
- **Estacionalidad:** Las reservas se concentran en julio y agosto (temporada alta), son moderadas de mayo a octubre (temporada media) y bajas en enero, febrero, noviembre y diciembre (temporada baja).  
- **Duración de estancias:** La duración promedio de estancia es mayor en el Resort Hotel que en el City Hotel, reflejando diferencias en el propósito del viaje.  
- **Cancelaciones:** Julio y agosto registran más cancelaciones, reflejando alta volatilidad en temporada alta, mientras que noviembre y diciembre tienen menos, lo que sugiere planes más estables en temporada baja.
- **Familias vs. Viajeros individuales:** La mayoría de las reservas son de adultos sin niños ni bebés, lo que indica que las familias constituyen un segmento minoritario. 
- **Necesidades de estacionamiento:** Las reservas con necesidad de estacionamiento muestran menor cancelación, reflejando mayor compromiso del cliente.
- **Anticipación de reservas:** Entre 2015 y 2016 aumentó la demanda y la anticipación en las reservas, tras una baja en 2014-2015.

---

## 🧪 Tecnologías Utilizadas

- RStudio  
- Paquetes:
  - `tidyverse`
  - `ggplot2`
  - `naniar`
  - `lubridate`
  - `gridExtra`
  - `plotly`
  - `knitr`
  - `mice`

---

## 📝 Licencia

Este proyecto está bajo la licencia **MIT** – ver el archivo `LICENSE` para más detalles.

---

## 📚 Contexto Académico

Este trabajo ha sido desarrollado como parte del **Trabajo 1 (TB1)** para el curso de **Fundamentos de Data Science (1ACC0216)** — *Universidad Peruana de Ciencias Aplicadas (UPC), 2025-1*.

