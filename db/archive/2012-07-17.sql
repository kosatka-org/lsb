ALTER TABLE `delivery_methods` ADD `is_local` TINYINT NOT NULL DEFAULT '0' AFTER `price` ,
ADD `image` VARCHAR( 255 ) NOT NULL AFTER `is_local`;


ALTER TABLE `payment_methods` ADD `is_local` TINYINT NOT NULL DEFAULT '0' AFTER `currency_id`;