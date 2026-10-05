-- Бизнес-вопрос: сколько минут в среднем проходит от создания заказа
-- до доставки, и как это меняется по дням?
-- Приёмы: несколько CTE, JOIN по заказу, EXTRACT(EPOCH ...).

WITH created AS (
    SELECT order_id,
           MIN(time) AS created_at
    FROM user_actions
    WHERE action = 'create_order'
    GROUP BY order_id
),
delivered AS (
    SELECT order_id,
           MAX(time) AS delivered_at
    FROM courier_actions
    WHERE action = 'deliver_order'
    GROUP BY order_id
)
SELECT c.created_at::date AS order_date,
       COUNT(*) AS delivered_orders,
       ROUND(AVG(EXTRACT(EPOCH FROM (d.delivered_at - c.created_at)) / 60)::numeric, 1)
           AS avg_delivery_min
FROM created c
JOIN delivered d ON d.order_id = c.order_id
GROUP BY c.created_at::date
ORDER BY order_date;
