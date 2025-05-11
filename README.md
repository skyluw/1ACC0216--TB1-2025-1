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

- **Preferencia por tipo de hotel:** [Conclusión sobre qué hotel tiene más demanda]  
- **Estacionalidad:** [Conclusión sobre temporadas alta, media y baja]  
- **Duración de estancias:** [Conclusión sobre duración promedio de estancias]  
- **Cancelaciones:** [Conclusión sobre patrones de cancelación]  
- **Familias vs. Viajeros individuales:** [Conclusión sobre huéspedes con/sin niños]  
- **Necesidades de estacionamiento:** [Conclusión sobre importancia del estacionamiento]  
- **Anticipación de reservas:** [Conclusión sobre lead time y su relación con cancelaciones]

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

