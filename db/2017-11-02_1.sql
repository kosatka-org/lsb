ALTER TABLE `sms_to_push_log` ADD `token` VARCHAR(255) NOT NULL AFTER `date`, ADD `body` TEXT(1000) NOT NULL AFTER `token`;
