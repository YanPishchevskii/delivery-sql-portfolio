-- Синтетические данные (никаких реальных данных в репозитории нет).
-- Запуск: psql -d <база> -f 01_schema/schema.sql -f 02_seed/seed.sql

INSERT INTO users
SELECT g, DATE '1970-01-01' + (random() * 12000)::int,
       CASE WHEN random() < 0.5 THEN 'male' ELSE 'female' END
FROM generate_series(1, 500) g;

INSERT INTO couriers
SELECT g, DATE '1970-01-01' + (random() * 10000)::int,
       CASE WHEN random() < 0.5 THEN 'male' ELSE 'female' END
FROM generate_series(1, 50) g;

INSERT INTO products
SELECT g, 'product_' || g, round((50 + random() * 450)::numeric, 2)
FROM generate_series(1, 40) g;

INSERT INTO orders
SELECT g,
       TIMESTAMP '2026-08-01' + random() * INTERVAL '60 days',
       ARRAY(SELECT (1 + random() * 39)::int
             FROM generate_series(1, 1 + (random() * 4)::int))
FROM generate_series(1, 5000) g;

INSERT INTO user_actions
SELECT 1 + (random() * 499)::int, order_id, 'create_order', creation_time
FROM orders;

-- ~10% заказов отменяются
INSERT INTO user_actions
SELECT ua.user_id, ua.order_id, 'cancel_order',
       ua.time + random() * INTERVAL '30 minutes'
FROM user_actions ua
WHERE ua.action = 'create_order' AND random() < 0.10;

-- Курьеры принимают и доставляют неотменённые заказы
INSERT INTO courier_actions
SELECT 1 + (random() * 49)::int, ua.order_id, 'accept_order',
       ua.time + random() * INTERVAL '10 minutes'
FROM user_actions ua
WHERE ua.action = 'create_order'
  AND NOT EXISTS (SELECT 1 FROM user_actions c
                  WHERE c.order_id = ua.order_id AND c.action = 'cancel_order');

INSERT INTO courier_actions
SELECT courier_id, order_id, 'deliver_order',
       time + INTERVAL '20 minutes' + random() * INTERVAL '40 minutes'
FROM courier_actions
WHERE action = 'accept_order';
