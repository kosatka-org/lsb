ALTER TABLE `warehouses` ADD `im_show` TINYINT(1) NOT NULL AFTER `spam_enabled`;
UPDATE `warehouses` SET `im_show`= 1 WHERE `shop_id` IN (1,3,4,5,1032,1033,1034,1050);