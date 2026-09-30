-- ============================================================
-- 🎯 QUERIES PROMOCIONALES BIGDATASTACK — @r2d2_coder
-- ============================================================
-- El gancho es la analítica REAL de mi plataforma.
-- La gente ve los datos reales → curiosidad → se registra.
-- ============================================================


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 1
-- GANCHO: "Tengo una plataforma con X alumnos.
--          Os enseño las métricas REALES con SQL."
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT
    COUNT(*) AS alumnos_totales,
    COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '7 days')
        AS nuevos_esta_semana,
    COUNT(*) FILTER (WHERE email_verified) AS verificados
FROM users;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 2
-- GANCHO: "Mis alumnos hacen X ejercicios al día en BigDataStack.
--          ¿Tú cuántos haces? (probablemente 0)"
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT
    DATE(created_at) AS dia,
    COUNT(*) AS ejercicios,
    COUNT(DISTINCT user_id) AS alumnos_activos,
    ROUND(COUNT(*)::numeric / COUNT(DISTINCT user_id), 1)
        AS ejercicios_por_alumno
FROM exercise_executions
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY DATE(created_at)
ORDER BY dia DESC;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 3
-- GANCHO: "La lección más difícil de BigDataStack tiene un 68% de
--          fallos. ¿Te atreves a intentarla? Link en bio."
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT l.title AS leccion, s.title AS skill,
    COUNT(*) AS intentos,
    ROUND(100.0 * SUM(CASE WHEN result != 'ok' THEN 1 ELSE 0 END)
        / COUNT(*), 1) AS tasa_fallo_pct
FROM exercise_executions ee
JOIN lessons l ON l.id = ee.lesson_id
JOIN skills s ON s.id = ee.skill_id
GROUP BY l.id, l.title, s.title
HAVING COUNT(*) > 20
ORDER BY tasa_fallo_pct DESC
LIMIT 3;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 4
-- GANCHO: "Solo el X% de los alumnos de BigDataStack completa
--          el módulo de SQL. ¿Tú serías capaz?"
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WITH avance AS (
    SELECT lp.user_id, s.title,
        COUNT(DISTINCT lp.lesson_id) AS hechas,
        (SELECT COUNT(*) FROM lessons WHERE skill_id = s.id) AS total
    FROM lesson_progress lp
    JOIN lessons l ON l.id = lp.lesson_id
    JOIN skills s ON s.id = l.skill_id
    GROUP BY lp.user_id, s.id, s.title
)
SELECT title AS modulo,
    COUNT(*) AS empezaron,
    COUNT(*) FILTER (WHERE hechas = total) AS terminaron,
    ROUND(100.0 * COUNT(*) FILTER (WHERE hechas = total)
        / COUNT(*), 1) AS pct_completado
FROM avance
GROUP BY title
ORDER BY pct_completado ASC;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 5
-- GANCHO: "Mis alumnos de BigDataStack tienen rachas de estudio
--          de 30+ días seguidos. El top 1 lleva X días."
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WITH dias AS (
    SELECT user_id, DATE(created_at) AS dia
    FROM exercise_executions
    GROUP BY user_id, DATE(created_at)
),
rachas AS (
    SELECT user_id, dia,
        dia - (ROW_NUMBER() OVER (
            PARTITION BY user_id ORDER BY dia))::int AS grupo
    FROM dias
)
SELECT u.name, COUNT(*) AS dias_de_racha
FROM rachas r
JOIN users u ON u.id = r.user_id
GROUP BY u.id, u.name, grupo
ORDER BY dias_de_racha DESC
LIMIT 100;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 7
-- GANCHO: "Ayer se registraron X personas en BigDataStack.
--          Os enseño cómo analizo los picos de registro." (DONE)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WITH diario AS (
    SELECT DATE(created_at) AS dia, COUNT(*) AS registros
    FROM users GROUP BY DATE(created_at)
)
SELECT dia, registros,
    ROUND(AVG(registros) OVER (ORDER BY dia ROWS BETWEEN 6 PRECEDING
        AND CURRENT ROW), 1) AS media_movil_7d
FROM diario
ORDER BY dia DESC
LIMIT 14;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 8
-- GANCHO: "El alumno más activo de BigDataStack ha hecho X
--          ejercicios. ¿Podrías superarlo?"
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT u.name,
    COUNT(*) AS ejercicios_totales,
    COUNT(*) FILTER (WHERE result = 'ok') AS aciertos,
    ROUND(100.0 * COUNT(*) FILTER (WHERE result = 'ok')
        / COUNT(*), 1) AS precision_pct
FROM exercise_executions ee
JOIN users u ON u.id = ee.user_id
WHERE u.ranking_visible = true
GROUP BY u.id, u.name
ORDER BY ejercicios_totales DESC
LIMIT 5;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 9
-- GANCHO: "En BigDataStack puedes aprender SQL o Python.
--          ¿Qué elige la gente? Los datos hablan."
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT language AS lenguaje,
    COUNT(DISTINCT user_id) AS alumnos,
    COUNT(*) AS ejercicios,
    ROUND(100.0 * COUNT(*) FILTER (WHERE result = 'ok')
        / COUNT(*), 1) AS acierto_pct
FROM exercise_executions
GROUP BY language;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 11
-- GANCHO: "Los alumnos de BigDataStack estudian más a las X de
--          la noche. ¿A qué hora estudias tú?"
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT EXTRACT(HOUR FROM created_at) AS hora,
    COUNT(*) AS ejercicios,
    COUNT(DISTINCT user_id) AS alumnos,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM exercise_executions
GROUP BY hora
ORDER BY ejercicios DESC
LIMIT 5;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 🎬 14
-- GANCHO: "X personas están en lista de espera para la siguiente
--          profesión de BigDataStack. ¿Te apuntas?" (TODO)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT t.title AS profesion, t.role,
    COUNT(ti.id) AS interesados,
    t.status
FROM tracks t
LEFT JOIN track_interests ti ON ti.track_id = t.id
GROUP BY t.id, t.title, t.role, t.status
ORDER BY interesados DESC;


-- ============================================================
-- 📋 ESTRUCTURA DEL VÍDEO:
-- ============================================================
-- 1. Gancho (dato real de BigDataStack, en texto grande, 2-3 seg)
-- 2. "Os lo demuestro con datos reales de mi plataforma"
-- 3. Query en pantalla, explicación rápida (10-15 seg)
-- 4. Resultado REAL ejecutado en la DB
-- 5. CTA: "Si quieres aprender a sacar estos insights,
--    en BigDataStack tienes ejercicios prácticos para hacerlo.
--    Link en bio 👇"
--
-- CLAVE: Cada vídeo muestra BigDataStack como producto REAL
-- con alumnos REALES y datos REALES. No es un anuncio,
-- es transparencia + educación = confianza + registros.
-- ============================================================
