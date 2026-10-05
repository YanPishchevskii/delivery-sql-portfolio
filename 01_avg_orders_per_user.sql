-- Бизнес-вопрос: сколько заказов в среднем оформляет один пользователь?

WITH user_orders AS (
    SELECT user_id,
           COUNT(DISTINCT order_id) AS orders_count
    FROM user_actions
    WHERE action = 'create_order'
    GROUP BY user_id
)
SELECT ROUND(AVG(orders_count), 2) AS orders_avg
FROM user_orders;
