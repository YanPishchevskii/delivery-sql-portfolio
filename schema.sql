-- Схема учебной базы сервиса доставки (PostgreSQL)

CREATE TABLE users (
    user_id    integer PRIMARY KEY,
    birth_date date,
    sex        varchar(10)
);

CREATE TABLE couriers (
    courier_id integer PRIMARY KEY,
    birth_date date,
    sex        varchar(10)
);

CREATE TABLE products (
    product_id integer PRIMARY KEY,
    name       varchar(100) NOT NULL,
    price      numeric(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id      integer PRIMARY KEY,
    creation_time timestamp NOT NULL,
    product_ids   integer[] NOT NULL
);

-- Действия клиента по заказу: create_order, cancel_order
CREATE TABLE user_actions (
    user_id  integer NOT NULL REFERENCES users (user_id),
    order_id integer NOT NULL,
    action   varchar(30) NOT NULL,
    time     timestamp NOT NULL
);

-- Действия курьера по заказу: accept_order, deliver_order
CREATE TABLE courier_actions (
    courier_id integer NOT NULL REFERENCES couriers (courier_id),
    order_id   integer NOT NULL,
    action     varchar(30) NOT NULL,
    time       timestamp NOT NULL
);

CREATE INDEX idx_user_actions_order ON user_actions (order_id);
CREATE INDEX idx_user_actions_user ON user_actions (user_id);
CREATE INDEX idx_courier_actions_order ON courier_actions (order_id);
