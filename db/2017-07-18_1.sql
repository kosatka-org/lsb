ALTER TABLE `services_orders` ADD `order_type` VARCHAR(50) NOT NULL DEFAULT 'default' AFTER `shop_id`;
