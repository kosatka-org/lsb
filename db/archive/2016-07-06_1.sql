CREATE TABLE IF NOT EXISTS `brand_names` (
  `id` int(16) NOT NULL AUTO_INCREMENT,
  `brand_id` int(16) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `brand_id` (`brand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
