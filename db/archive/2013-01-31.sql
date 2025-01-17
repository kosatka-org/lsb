CREATE TABLE IF NOT EXISTS `emails` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `sender_email` varchar(64) NOT NULL,
  `sender_name` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `alias` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body_html` text,
  `body_text` text,
  `state` int(1) DEFAULT '0',
  `variables` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `alias` (`alias`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
