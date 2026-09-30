# 🏭 Flujos del día a día de un Data Engineer

Serie de notebooks en PySpark que explican los flujos de trabajo
más habituales de un ingeniero de datos. Cada archivo es un flujo
completo, autocontenido y ejecutable.

Se ejecutan con el entorno Docker del repo (ver
`.kiro/steering/pyspark-docker.md`):

```
docker compose up -d
```
y abrir `http://localhost:8888/lab?token=spark` →
carpeta `work/flujos_data_engineer/`.

## Los flujos

| # | Notebook | Qué enseña |
|---|----------|-----------|
| 1 | `01_etl_clasico.ipynb` | El ETL de toda la vida: Extract → Clean → Join → Transform → Load |
| 2 | `02_deduplicacion_cdc.ipynb` | Quedarte con el último registro de cada clave (Window row_number) |
| 3 | `03_calidad_datos.ipynb` | Auditar una tabla: nulos, duplicados, valores fuera de rango |
| 4 | `04_modelo_estrella.ipynb` | Unir hechos + dimensiones (broadcast joins) en una tabla ancha |
| 5 | `05_metricas_kpis.ipynb` | KPIs: totales, acumulados (running total), variación (lag), rankings |

## Ideas de vídeo

Cada notebook da para un vídeo "un día en la vida de un data engineer"
o "esto lo haces todos los días en Spark". Se pueden enseñar celda a
celda explicando cada paso del flujo.
