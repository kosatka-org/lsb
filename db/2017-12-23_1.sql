CREATE TABLE IF NOT EXISTS `delivery_to_tk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_ids` varchar(255) NOT NULL,
  `price` float(10,2) NOT NULL,
  `manager_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;