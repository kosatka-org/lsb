ALTER TABLE `shop_cashbox` ADD `entity_id` INT NOT NULL AFTER `entity`;

ALTER TABLE `items` ADD `entity_id` INT NOT NULL AFTER `warehouse_id`;

CREATE TABLE `entities` ( `id` INT NOT NULL AUTO_INCREMENT , `name` VARCHAR(100) NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;
