ALTER TABLE `products` ADD `show_out_of_stock` TINYINT(1) NOT NULL DEFAULT '0' AFTER `coll_active`, ADD INDEX `show_out_of_stock` (`show_out_of_stock`);
