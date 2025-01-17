ALTER TABLE `users` ADD `decline_rate` INT(11) NOT NULL AFTER `sales_target`;
UPDATE `users` SET `decline_rate` = 45 WHERE `group_id` > 1;