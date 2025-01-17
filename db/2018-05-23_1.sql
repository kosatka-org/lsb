

CREATE TABLE IF NOT EXISTS `sber_transactions` (
  `amount` decimal(8,2) unsigned NOT NULL DEFAULT '0.00',
  `md_order` varchar(64) NOT NULL,
  `operation` varchar(32) NOT NULL,
  `order_key` varchar(255) NOT NULL,
  `status` tinyint(1) unsigned NOT NULL,
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

