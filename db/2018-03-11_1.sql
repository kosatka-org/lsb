CREATE TABLE IF NOT EXISTS `apple_devices2pkpasses` (
  `reg_id` int(11) NOT NULL AUTO_INCREMENT,
  `pass_id` int(11) NOT NULL,
  `pass_type` varchar(255) NOT NULL,
  `device_l_id` varchar(255) NOT NULL,
  PRIMARY KEY (`reg_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;