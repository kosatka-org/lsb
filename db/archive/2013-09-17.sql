ALTER TABLE  `orders` ADD  `delivery_agent_price` FLOAT( 10, 2 ) NOT NULL DEFAULT  '0.00';
ALTER TABLE  `orders` ADD  `invoice_number` VARCHAR( 32 ) NOT NULL AFTER  `delivery_code`;


ALTER TABLE `users_crm` CHANGE `type` `type` ENUM( 'sms', 'email', 'call', 'message', 'subscribe', 'buy', 'failure', 'order' ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;