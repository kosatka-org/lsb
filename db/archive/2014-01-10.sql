ALTER TABLE  `products` ADD  `last_price_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
UPDATE products SET last_price_update = created;