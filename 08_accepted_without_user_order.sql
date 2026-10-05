-- Бизнес-вопрос: сколько заказов приняли курьеры, хотя у клиентов
-- нет записи об их создании? (проверка целостности данных)

SELECT COUNT(DISTINCT ca.order_id) AS orders_count
FROM courier_actions ca
WHERE ca.action = 'accept_order'
  AND NOT EXISTS (
      SELECT 1
      FROM user_actions ua
      WHERE ua.order_id = ca.order_id
        AND ua.action = 'create_order'
  );
