-- Бизнес-вопрос: как меняется выручка по дням и насколько она выросла
-- относительно предыдущего дня?
-- Допущение: выручка считается только по неотменённым заказам.
-- Приёмы: unnest массива, CTE, оконная функция LAG.

WITH order_items AS (
    SELECT o.order_id,
           o.creation_time::date AS order_date,
           UNNEST(o.product_ids) AS product_id
    FROM orders o
    WHERE NOT EXISTS (
        SELECT 1
        FROM user_actions ua
        WHERE ua.order_id = o.order_id
          AND ua.action = 'cancel_order'
    )
),
daily_revenue AS (
    SELECT oi.order_date,
           SUM(p.price) AS revenue
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY oi.order_date
)
SELECT order_date,
       revenue,
       LAG(revenue) OVER (ORDER BY order_date) AS prev_revenue,
       ROUND(
           100.0 * (revenue - LAG(revenue) OVER (ORDER BY order_date))
           / NULLIF(LAG(revenue) OVER (ORDER BY order_date), 0),
           2
       ) AS growth_pct
FROM daily_revenue
ORDER BY order_date;
