# RetailPro | Analytics & Business Intelligence Project

Repositorio oficial del proyecto de análisis comercial y diagnóstico de rentabilidad para **RetailPro (TechStore)**, desarrollado en el marco del curso de Data Analytics de CoderHouse.

---

## 📌 Contexto y Diagnóstico del Negocio
A pesar de registrar un crecimiento sostenido en el volumen transaccional (+10% en unidades vendidas), la gerencia detectó una contracción alarmante del **20% en el margen bruto en la región Sur**. 

El objetivo de este proyecto es construir un pipeline integral de datos (SQL, Power Query, Modelado Estrella y DAX) para identificar las causas raíz de la fuga de margen y formular recomendaciones operativas orientadas a precios, mix de productos y canales de venta.

---

## 🛠️ Stack Tecnológico y Arquitectura
- **Motor de Base de Datos:** MySQL Server 8.0
- **Extracción y Limpieza (ETL):** Power Query (Lenguaje M)
- **Modelado y Analítica:** Power BI Desktop (Esquema en estrella, DAX Time Intelligence)
- **Control de Versiones:** Git & GitHub

---

## 📂 Estructura del Repositorio
```text
├── sql/
│   ├── 01_schema_creation.sql       # Creación de tablas y claves foráneas
│   ├── 02_data_insertion.sql        # Poblado inicial de transacciones
│   └── 03_analytical_queries.sql    # Consultas agregadas, JOINs y rankings
├── powerbi/
│   ├── Pipeline_ETL_Meritano_Nicolas.pbix   # Transformaciones Power Query
│   └── Meritano_Nicolas_Checkpoint2.pbix     # Modelo de datos, calendario y DAX
├── docs/
│   └── Wireframe_Dashboard_Z_Pattern.pdf   # Boceto y arquitectura visual
└── README.md
