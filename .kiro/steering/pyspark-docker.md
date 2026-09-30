# PySpark con Docker

Este repo usa Docker para ejecutar los notebooks de PySpark, porque en
Windows nativo Spark da problemas (winutils, el worker de Python que no
conecta, y crashes de las UDFs con caracteres no-ASCII como `€`).
Dentro del contenedor Spark corre sobre Linux y todo funciona.

## Arrancar el entorno

Desde la raíz del repo:

```bash
docker compose up -d
```

- La primera vez descarga la imagen `quay.io/jupyter/pyspark-notebook`
  (unos GB, sobre Linux).
- Luego levanta Jupyter Lab y deja el repo montado en `work/`.

## Abrir un notebook

1. Navegador en: `http://localhost:8888/lab?token=spark`
   (si pide token, es `spark`).
2. Panel izquierdo: `work/` → carpeta de la categoría → el `.ipynb`.
3. Ejecutar: **Shift+Enter** celda a celda, o **Run → Run All Cells**.

Atajo directo a un notebook concreto:

```
http://localhost:8888/lab/tree/work/junior_vs_senior/pyspark_junior_vs_senior.ipynb?token=spark
```

La primera celda (crear la `SparkSession`) tarda ~10-15 s porque arranca
Spark. Es normal.

## Ver los jobs de Spark (para grabar vídeo)

Mientras corre una celda, la Spark UI está en `http://localhost:4040`.
Ahí se ve el DAG, las stages y los tasks. Queda muy bien en cámara para
enseñar el paralelismo del enfoque "senior".

## Parar el entorno

```bash
docker compose down
```

## Cómo está montado (docker-compose.yml)

- Imagen: `quay.io/jupyter/pyspark-notebook:latest`
- Puertos: `8888` (Jupyter Lab) y `4040` (Spark UI)
- Volumen: `./:/home/jovyan/work` (todo el repo)
- Token fijo: `spark`
- `PYTHONPATH` apunta al Spark de la imagen para que `import pyspark`
  funcione desde el kernel:
  `/usr/local/spark/python:/usr/local/spark/python/lib/py4j-0.10.9.9-src.zip`

> Nota: si actualizas la imagen y cambia la versión de py4j, hay que
> ajustar el nombre del zip en el `PYTHONPATH` del compose. Para saber el
> nombre exacto: `docker exec ejercicios-pyspark ls /usr/local/spark/python/lib/`

## Validar un notebook sin abrir el navegador

Para comprobar que un notebook corre entero sin errores:

```bash
docker exec ejercicios-pyspark jupyter nbconvert --to notebook --execute \
  --output /tmp/out.ipynb \
  /home/jovyan/work/junior_vs_senior/pyspark_junior_vs_senior.ipynb
```

Si termina sin excepción, el notebook está OK.

## Reglas al escribir notebooks de PySpark en este repo

- NO hace falta configurar `PYSPARK_PYTHON` ni hacks de Windows dentro del
  notebook: el contenedor ya lo resuelve. Mantener las celdas limpias.
- Las UDFs de Python funcionan dentro de Docker, pero recuerda que el
  ángulo "junior vs senior" es que el junior usa `collect()`/UDFs (trae
  datos al driver o rompe la optimización) y el senior usa operaciones
  nativas distribuidas (`filter`, `groupBy`, `when`, `join`, `Window`,
  `regexp_replace`...).
