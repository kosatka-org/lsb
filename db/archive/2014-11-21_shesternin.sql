ALTER TABLE `categories` ADD `type_id` TINYINT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'тип одежды: 0 - не определенно, 1 - верх, 2 - низ, 3 -обувь' AFTER `category_id` ;

UPDATE `categories` SET `type_id` = '3' WHERE parent = 2;

UPDATE `categories` SET `type_id` = '0' WHERE parent = 38;

UPDATE `categories` SET `type_id` = '0' WHERE parent = 4;
