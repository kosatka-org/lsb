ALTER TABLE `orders` ADD `weight` TINYINT UNSIGNED NOT NULL DEFAULT '2' AFTER `barcode`;

ALTER TABLE `orders` ADD `city` VARCHAR( 255 ) NOT NULL AFTER `address` ,
ADD `region` VARCHAR( 255 ) NOT NULL AFTER `city` ,
ADD `country` VARCHAR( 255 ) NOT NULL DEFAULT 'Россия' AFTER `region`;

