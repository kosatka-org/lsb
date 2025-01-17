CREATE TABLE `lsboutique`.`movements` ( `movement_id` INT NOT NULL AUTO_INCREMENT , `shop_from` INT NOT NULL , `shop_to` INT NOT NULL , `date` TIMESTAMP NOT NULL , PRIMARY KEY (`movement_id`)) ENGINE = InnoDB;

CREATE TABLE `lsboutique`.`movement_items` ( `movement_id` INT NOT NULL , `item_id` INT NOT NULL , INDEX `movement` (`movement_id`), INDEX `item` (`item_id`)) ENGINE = InnoDB;
