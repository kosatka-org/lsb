ALTER TABLE `movements` ADD `reservation_returned` TINYINT(1) NOT NULL DEFAULT '0' AFTER `user_id`;
