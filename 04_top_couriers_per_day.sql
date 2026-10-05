-- Бизнес-вопрос: какие три курьера доставили больше всего заказов
-- в каждый день?
-- Приёмы: CTE, ROW_NUMBER с PARTITION BY.

WITH daily_deliveries AS (
    SELECT courier_id,
           time::date AS delivery_date,
           COUNT(DISTINCT order_id) AS orders_count
    FROM courier_actions
    WHERE action = 'deliver_order'
    GROUP BY courier_id, time::date
),
ranked AS (
    SELECT delivery_date,
           courier_id,
           orders_count,
           ROW_NUMBER() OVER (
               PARTITION BY delivery_date
               ORDER BY orders_count DESC, courier_id
           ) AS rank_in_day
    FROM daily_deliveries
)
SELECT delivery_date, rank_in_day, courier_id, orders_count
FROM ranked
WHERE rank_in_day <= 3
ORDER BY delivery_date, rank_in_day;
