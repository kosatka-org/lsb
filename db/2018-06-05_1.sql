ALTER TABLE `services_orders_items` ADD `product_name` VARCHAR(100) NOT NULL AFTER `status`, ADD `defect_description` VARCHAR(100) NOT NULL AFTER `product_name`;
