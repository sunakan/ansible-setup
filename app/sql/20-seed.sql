-- 一時的に外部キー制約を無効化し、TRUNCATE後に戻す
set foreign_key_checks = 0;
truncate table orders;
truncate table users;
truncate table products;
set foreign_key_checks = 1;

INSERT INTO users (email, payments_customer_id, payments_payment_method_id, created_at, updated_at)
VALUES
('pat@example.com', 'customer_id-red-apple-123', 'payment_method_id-yellow-banana-456', NOW(), NOW())
;

INSERT INTO products (name, quantity_remaining, price_cents, created_at, updated_at)
VALUES 
('MacBook Pro(M4)',          100, 12300,  NOW(), NOW())
, ('Mac mini(M4)',           4,   567800, NOW(), NOW())
, ('iPhone',                 32,  76599,  NOW(), NOW())
, ('iPad', 300, 1244,   NOW(), NOW())
;
