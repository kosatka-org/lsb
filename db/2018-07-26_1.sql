CREATE TABLE IF NOT EXISTS `cities_totals` (
  `city_id` int(10) NOT NULL,
  `status` int(11) NOT NULL,
  `total` int(15) NOT NULL,
  PRIMARY KEY (`city_id`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
