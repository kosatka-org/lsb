CREATE TABLE IF NOT EXISTS `users2sizes` (
  `user_id` smallint(5) unsigned NOT NULL,
  `type_id` tinyint(3) unsigned NOT NULL COMMENT '1-верх, 2-низ, 3-обувь',
  `size` varchar(4) NOT NULL,
  UNIQUE KEY `user_id` (`user_id`,`type_id`,`size`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `users2products` (
  `user_id` mediumint(8) unsigned NOT NULL,
  `product_id` mediumint(8) unsigned NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
