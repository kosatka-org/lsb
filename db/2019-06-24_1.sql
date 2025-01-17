ALTER TABLE `products` ADD `uuid` VARCHAR(255) NOT NULL AFTER `stretch`;
ALTER TABLE `orders` ADD `uuid` VARCHAR(255) NOT NULL AFTER `promo_sale`;
