CREATE TABLE IF NOT EXISTS `web_sessions` (
  `id` int(16) NOT NULL AUTO_INCREMENT,
  `phpsessid` varchar(50) NOT NULL,
  `user_agent` varchar(500) NOT NULL,
  `ip` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phpsessid` (`phpsessid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

ALTER TABLE  `web_sessions` ADD  `created` DATETIME NOT NULL ,
ADD  `updated` DATETIME NOT NULL ;

CREATE TABLE IF NOT EXISTS `users2web_sessions` (
  `user_id` int(16) NOT NULL,
  `web_session_id` int(16) NOT NULL,
  UNIQUE KEY `unique_pair` (`user_id`,`web_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `product_views` (
  `id` int(16) NOT NULL AUTO_INCREMENT,
  `product_id` int(16) NOT NULL,
  `web_session_id` int(16) NOT NULL,
  `user_id` int(16) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`,`web_session_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;