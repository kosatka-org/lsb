CREATE TABLE IF NOT EXISTS `sr_manager2users` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `manager_id` int(12) NOT NULL,
  `user_id` int(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;