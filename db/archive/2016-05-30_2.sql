CREATE TABLE IF NOT EXISTS `messengers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `icon` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `messengers` (`id`,`name`,`icon`)
VALUES 
(NULL,'Telegram','telegram.png'),
(NULL,'Viber','viber.png'),
(NULL,'Watsapp','watsapp.png'),
(NULL,'Wechat','wechat.png'),
(NULL,'Facetime','facetime.png'),
(NULL,'FB messenger','FBmessenger.png'),
(NULL,'Hangouts','hangouts.png'),
(NULL,'Allo','allo.png'),
(NULL,'Skype','skype.png');

