CREATE TABLE IF NOT EXISTS `stop_list_history` (
  `user_id` int(11) NOT NULL,
  `manager_id` int(11) NOT NULL,
  `type` tinyint(3) NOT NULL COMMENT '0 - sms, 1 - email',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `user_id` (`user_id`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;