ALTER TABLE `orders_products` ADD `status_date` DATE NOT NULL AFTER `status`;

ALTER TABLE `orders_products` ADD `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE `orders` ADD `real_delivery_price` FLOAT( 10, 2 ) NOT NULL DEFAULT '0' AFTER `delivery_price`;

UPDATE `orders` SET `real_delivery_price` = `delivery_price`;