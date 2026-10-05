-- Бизнес-вопрос: какая доля заказов отменяется в разрезе пола
-- и возрастной группы клиента?
-- Возраст считается на момент создания заказа.
-- Приёмы: CTE, CASE, EXISTS, FILTER, AGE.

WITH created_orders AS (
    SELECT DISTINCT user_id, order_id, time
    FROM user_actions
    WHERE action = 'create_order'
),
orders_enriched AS (
    SELECT c.order_id,
           COALESCE(u.sex, 'unknown') AS sex,
           CASE
               WHEN u.birth_date IS NULL THEN 'unknown'
               WHEN DATE_PART('year', AGE(c.time, u.birth_date)) < 25 THEN '<25'
               WHEN DATE_PART('year', AGE(c.time, u.birth_date)) < 35 THEN '25-34'
               WHEN DATE_PART('year', AGE(c.time, u.birth_date)) < 45 THEN '35-44'
               ELSE '45+'
           END AS age_group,
           EXISTS (
               SELECT 1
               FROM user_actions x
               WHERE x.order_id = c.order_id
                 AND x.action = 'cancel_order'
           ) AS is_cancelled
    FROM created_orders c
    JOIN users u ON u.user_id = c.user_id
)
SELECT sex,
       age_group,
       COUNT(*) AS total_orders,
       COUNT(*) FILTER (WHERE is_cancelled) AS cancelled_orders,
       ROUND(100.0 * COUNT(*) FILTER (WHERE is_cancelled) / COUNT(*), 2) AS cancel_rate_pct
FROM orders_enriched
GROUP BY sex, age_group
ORDER BY sex, age_group;
