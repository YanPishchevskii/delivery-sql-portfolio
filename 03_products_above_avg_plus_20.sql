-- Бизнес-вопрос: какие товары дороже средней цены как минимум на 20 рублей?

SELECT product_id, name, price
FROM products
WHERE price >= (SELECT AVG(price) FROM products) + 20
ORDER BY product_id DESC;
