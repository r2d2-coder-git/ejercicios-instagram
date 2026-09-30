# PySpark con Docker 🐳⚡

Para grabar los ejercicios de PySpark sin pelearte con Windows
(winutils, workers que no conectan, crashes de UDFs), corre Spark
dentro de un contenedor Linux.

## Arrancar el entorno

Desde la raíz del repo:

```bash
docker compose up
```

La primera vez descarga la imagen (unos GB). Luego abre:

```
http://localhost:8888/lab?token=spark
```

El repo entero está montado en `work/`, así que verás los notebooks
ahí dentro y todo lo que edites se guarda en tu disco.

## Ver los jobs de Spark (para el vídeo)

Mientras corre una celda, la Spark UI está en:

```
http://localhost:4040
```

Ahí se ve el DAG, las stages y los tasks. Queda genial en cámara para
enseñar el paralelismo del enfoque "senior".

## Parar el entorno

```bash
docker compose down
```

## Nota

Dentro del contenedor NO hace falta configurar `PYSPARK_PYTHON` ni nada:
Spark corre sobre Linux y las UDFs funcionan sin problemas.
