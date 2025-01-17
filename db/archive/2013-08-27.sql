ALTER TABLE `users` ADD `last_sms_send` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' AFTER `stop_sms`;

ALTER TABLE `users_crm` ADD `subject` VARCHAR( 255 ) NOT NULL AFTER `type`;

ALTER TABLE `users_crm` CHANGE `type` `type` ENUM( 'sms', 'email', 'call', 'message', 'subscribe', 'buy' ) NOT NULL ;