-- Бизнес-вопрос: какие заказы не были отменены?
-- NOT EXISTS безопаснее NOT IN: не ломается из-за NULL.

SELECT DISTINCT ua.order_id
FROM user_actions ua
WHERE NOT EXISTS (
    SELECT 1
    FROM user_actions c
    WHERE c.order_id = ua.order_id
      AND c.action = 'cancel_order'
)
ORDER BY ua.order_id
LIMIT 1000;
