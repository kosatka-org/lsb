ALTER TABLE `movements` ADD `movement_id_1s` INT NOT NULL AFTER `date`, ADD INDEX `1s_id` (`movement_id_1s`);
