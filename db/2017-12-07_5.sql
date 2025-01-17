ALTER TABLE `items` ADD `size_type` INT(8) NOT NULL AFTER `size`;
ALTER TABLE `items` ADD `size_system` VARCHAR(30) NOT NULL AFTER `size`;
