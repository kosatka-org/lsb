ALTER TABLE `users` ADD `last_phone_call` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' AFTER `last_sms_send`;

ALTER TABLE `users` ADD `last_phone_call_status` TINYINT NOT NULL DEFAULT '0' COMMENT '0 - не звонили, 1 - не дозвонились, 2 - дозвонились' AFTER `last_phone_call`;

ALTER TABLE `users_crm` CHANGE `type` `type` ENUM( 'sms', 'email', 'call', 'call_failed', 'subscribe', 'buy', 'failure', 'order' ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ;