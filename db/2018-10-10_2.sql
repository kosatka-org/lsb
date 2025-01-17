ALTER TABLE `warehouses` ADD `user_id` INT NOT NULL AFTER `shop_id`, ADD `confirm` TINYINT(1) NOT NULL DEFAULT '0' AFTER `user_id`;
