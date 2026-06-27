# 🎬 Guión: Predicción España vs Uruguay (1 minuto)

## 🎙️ HOOK (0-5s)
**[Mostrar título del notebook]**

"Voy a predecir el España-Uruguay del viernes con Python y 47.000 partidos reales."

---

## 📥 DATOS (5-18s)
**[Ejecutar celda de carga de datos + H2H]**

"Cargo un dataset público con todos los partidos internacionales desde 1872. De aquí saco el historial directo: España no ha perdido NUNCA contra Uruguay. Y calculo la forma reciente de cada selección con sus últimos 20 partidos."

---

## 🧮 MODELO (18-32s)
**[Mostrar celda de fuerza ofensiva/defensiva + lambdas]**

"Con los partidos desde 2022 calculo la fuerza ofensiva y defensiva de cada equipo comparada con la media global. Eso me da los goles esperados con Poisson. España marca más y recibe menos, así que su lambda es más alto."

---

## 🎲 SIMULACIÓN (32-42s)
**[Ejecutar Monte Carlo + resultados]**

"Simulo el partido 100.000 veces con Monte Carlo... Y sale: España gana un [X]%, empate [X]%, Uruguay [X]%. El marcador más probable: [X-X]."

---

## 📈 GRÁFICOS (42-52s)
**[Mostrar panel de 4 gráficos]**

"Aquí veis las probabilidades, el heatmap de marcadores, la distribución de goles de cada equipo y el historial directo. Todo calculado de datos, cero inventado."

---

## 🎯 CIERRE (52-60s)
**[Mostrar cuadro resumen]**

"Predicción final: España [X]-[X] Uruguay. Pero es un Mundial y Uruguay se juega todo. ¿Vosotros qué veis? Comentarios."

---

## ⏱️ NOTAS DE PRODUCCIÓN
- El gancho es "47.000 partidos reales" — eso da credibilidad al instante
- La celda de carga tarda 2-3 segundos, perfecto para mostrar que es real
- Puedes hacer zoom al print del H2H que muestra los partidos reales
- Los [X] se rellenan al ejecutar
- Si te pasas de 60s, la sección de gráficos (42-52s) es la más fácil de acelerar con x1.5
