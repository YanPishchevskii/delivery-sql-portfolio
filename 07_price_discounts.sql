-- Бизнес-вопрос: какую цену получит каждый товар после скидки?
-- Правила: дороже средней на 50+ руб. -> скидка 15%;
--          дешевле средней на 50+ руб. -> скидка 10%; иначе без скидки.

WITH avg_price AS (
    SELECT ROUND(AVG(price), 2) AS value
    FROM products
)
SELECT product_id,
       name,
       price,
       CASE
           WHEN price - (SELECT value FROM avg_price) >= 50 THEN price * 0.85
           WHEN (SELECT value FROM avg_price) - price >= 50 THEN price * 0.90
           ELSE price
       END AS new_price
FROM products
ORDER BY price DESC, product_id ASC;
