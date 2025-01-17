ALTER TABLE `users2wishlist` ADD `price` INT UNSIGNED NOT NULL DEFAULT '0';

UPDATE `users2wishlist` AS u2w SET `price` = ( SELECT p.price FROM products AS p WHERE u2w.product_id = p.product_id );