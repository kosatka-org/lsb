ALTER TABLE `premoderation_items` ADD `sex` VARCHAR(20) NOT NULL AFTER `order_number`, ADD `material` VARCHAR(100) NOT NULL AFTER `sex`, ADD `supplier` VARCHAR(50) NOT NULL AFTER `material`;
