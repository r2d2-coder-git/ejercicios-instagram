-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--    "¿CUÁNTAS PERSONAS SE REGISTRAN A DIARIO 
--     EN BIGDATASTACK.DEV?"
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WITH diarios AS (
    SELECT DATE(created_at) AS dia, COUNT(*) AS registros
    FROM users
    GROUP BY DATE(created_at)
)

SELECT dia, registros,
        ROUND(AVG(registros) OVER(ORDER BY dia
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),1)
        AS media_movil_7d
FROM diarios
ORDER BY dia DESC
LIMIT 14;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ¿Cuántas personas están en lista de espera 
--para la siguiente profesión de BigDataStack. 
-- ¿Te apuntas?"
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT t.title as profesion,
        count(ti.id) as interesados
FROM tracks t
LEFT JOIN track_interests ti on ti.track_id = t.id
GROUP BY t.id
ORDER BY interesados DESC;