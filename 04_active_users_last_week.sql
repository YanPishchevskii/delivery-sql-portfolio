-- Бизнес-вопрос: сколько уникальных пользователей совершали действия
-- за неделю, предшествующую последнему созданному заказу?
-- Допущение: окно считается от времени последнего create_order,
-- а пользователи учитываются по любым действиям.
-- Если нужны только оформившие заказ, добавьте action = 'create_order' во внешний WHERE.

WITH period_start AS (
    SELECT MAX(time) - INTERVAL '1 week' AS start_time
    FROM user_actions
    WHERE action = 'create_order'
)
SELECT COUNT(DISTINCT user_id) AS users_count
FROM user_actions
WHERE time >= (SELECT start_time FROM period_start);
