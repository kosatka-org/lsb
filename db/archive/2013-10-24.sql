ALTER TABLE `prodazhi` ADD `card_prepeared` VARCHAR( 16 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `card`;

UPDATE `prodazhi` SET `card_prepeared` = SUBSTR(REPLACE(REPLACE(`card`, '?', ''), ' ', ''), -16) WHERE card <> '' AND `card_prepeared` = '';
UPDATE `prodazhi` SET `card_prepeared` = `card` WHERE card <> '' AND `card_prepeared` = '';

ALTER TABLE `prodazhi` ADD INDEX ( `card_prepeared` );

ALTER TABLE `prodazhi` ADD `user_id` MEDIUMINT UNSIGNED NOT NULL AFTER `card_prepeared`;

ALTER TABLE `users` ADD `card_prepeared` VARCHAR( 16 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `card_number`;

UPDATE `users` SET `card_prepeared` = SUBSTR(REPLACE(REPLACE(`card_number`, '?', ''), ' ', ''), -16) WHERE card_number <> '' AND `card_prepeared` = '';
UPDATE `users` SET `card_prepeared` = `card_number` WHERE card_number <> '' AND `card_prepeared` = '';


ALTER TABLE `users` ADD INDEX ( `card_prepeared` );

ALTER TABLE `discount` ADD `card_prepeared` VARCHAR( 16 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `card_number`;

UPDATE `discount` SET `card_prepeared` = SUBSTR(REPLACE(REPLACE(`card_number`, '?', ''), ' ', ''), -16) WHERE card_number <> '' AND `card_prepeared` = '';
UPDATE `discount` SET `card_prepeared` = `card_number` WHERE card_number <> '' AND `card_prepeared` = '';

ALTER TABLE `discount` ADD INDEX ( `card_prepeared` );

ALTER TABLE `discount` ADD `user_id` MEDIUMINT UNSIGNED NOT NULL AFTER `card_prepeared`;

UPDATE `prodazhi` p SET user_id = (SELECT original_user_id FROM `users` u WHERE u.`card_prepeared` = p.`card_prepeared` LIMIT 1) WHERE user_id = 0 AND p.`card_prepeared` <> '';

UPDATE `discount` p SET user_id = (SELECT original_user_id FROM `users` u WHERE u.`card_prepeared` = p.`card_prepeared` LIMIT 1) WHERE user_id = 0 AND p.`card_prepeared` <> '';

ALTER TABLE `prodazhi` ADD `brand_id` INT UNSIGNED NOT NULL DEFAULT '0' AFTER `brand`;