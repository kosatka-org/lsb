ALTER TABLE `warehouses` ADD COLUMN `shop_id` int(11) NOT NULL;

ALTER TABLE `movements` CHANGE COLUMN `shop_from` `warehouse_from` INT NOT NULL;
ALTER TABLE `movements` CHANGE COLUMN `shop_to` `warehouse_to` INT NOT NULL;
