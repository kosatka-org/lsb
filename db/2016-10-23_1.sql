ALTER TABLE `users` ADD `cashbox_id` TINYINT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Id кассы к которой прикреплен аккаунт менеджера-кассира';

ALTER TABLE `orders` ADD `cashbox_id` TINYINT UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Id кассы на которой пробили заказ';

CREATE TABLE IF NOT EXISTS `orders_payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `payment_id` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Способ оплаты заказа',
  `money_paid` decimal(8,2) unsigned NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `payment_offline` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;


INSERT INTO `payment_offline` (`id`, `name`, `enabled`) VALUES
(1, 'Наличные', 1),
(2, 'Терминал Сбербанк', 1),
(3, 'Терминал ВТБ24', 1),
(4, 'Долг', 1),
(NULL, 'Сертификат', '1');



CREATE TABLE IF NOT EXISTS `shop_cashbox` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `shop_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `payments_ids` varchar(64) NOT NULL DEFAULT '' COMMENT 'способы оплаты, доступные на кассе, id, через запятую',
  `enabled` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;


INSERT INTO `shop_cashbox` (`id`, `name`, `shop_id`, `payments_ids`, `enabled`) VALUES
(1, 'Тестовая касса НВН', 1, '1,2,3,4', 1);
