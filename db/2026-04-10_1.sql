ALTER TABLE `items` ADD COLUMN `price` int UNSIGNED NULL AFTER `entity_id`;

UPDATE `items` SET `price` = 5000 WHERE `item_id` = 633525;

UPDATE `items` SET `price` = 10000 WHERE `item_id` = 633526;

UPDATE `items` SET `price` = 15000 WHERE `item_id` = 633527;

UPDATE `items` SET `price` = 20000 WHERE `item_id` = 638080;
