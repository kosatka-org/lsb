ALTER TABLE `orders` ADD `mtm_brand_id` INT(8) NOT NULL AFTER `courier_id`;
ALTER TABLE `orders_products` ADD `mtm_status` VARCHAR(100) NOT NULL AFTER `one_click_id`;
