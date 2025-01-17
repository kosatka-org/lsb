ALTER TABLE `products` ADD `new_stuff` TINYINT UNSIGNED NOT NULL DEFAULT '0' AFTER `created`;

UPDATE `products` SET `new_stuff` = '1' WHERE 1;