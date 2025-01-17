CREATE TABLE IF NOT EXISTS `app_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `push_token` varchar(500) NOT NULL,
  `platform` varchar(100) NOT NULL,
  `user_id` int(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;