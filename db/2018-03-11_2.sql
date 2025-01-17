CREATE TABLE IF NOT EXISTS `apple_devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `push_token` varchar(255) NOT NULL,
  `device_l_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;