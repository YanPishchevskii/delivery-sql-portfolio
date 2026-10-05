-- Бизнес-вопрос: насколько число неотменённых заказов каждого пользователя
-- отличается от среднего по пользователям?
-- Допущение: отменённые заказы исключаются целиком (а не только строки cancel_order).

WITH user_orders AS (
    SELECT user_id,
           COUNT(DISTINCT order_id) AS orders_count
    FROM user_actions
    WHERE order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
    GROUP BY user_id
)
SELECT user_id,
       orders_count,
       ROUND(AVG(orders_count) OVER (), 2) AS orders_avg,
       orders_count - ROUND(AVG(orders_count) OVER (), 2) AS orders_diff
FROM user_orders
ORDER BY user_id
LIMIT 1000;
