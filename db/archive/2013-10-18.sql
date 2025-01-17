ALTER TABLE `users` ADD `new_user_database` TINYINT( 1 ) NOT NULL DEFAULT '1' COMMENT 'флаг показывает из какой клиентской базы' AFTER `enabled`;

ALTER TABLE `users` CHANGE `shop` `shop` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'Internet';

UPDATE `users` SET new_user_database = '1' WHERE `shop` = 'Internet' OR SUBSTRING(`card_number`, -16) IN ( SELECT SUBSTRING(`number`, -16) FROM `cards` )