CREATE TABLE IF NOT EXISTS `users2carts` (
  `user_id` int(10) unsigned NOT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `size` varchar(16) NOT NULL,
  `count` tinyint(4) NOT NULL,
  `price` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`product_id`,`size`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
