CREATE TABLE IF NOT EXISTS `emails_senders` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `hostname` varchar(64) NOT NULL,
  `login` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Хранилище SMTP рассыльщиков' AUTO_INCREMENT=5 ;

--
-- Dumping data for table `emails_senders`
--

INSERT INTO `emails_senders` (`id`, `hostname`, `login`, `password`, `active`) VALUES
(1, 'smtp.mailgun.org', 'postmaster@ls.net.ru', '294e4a2217efd2489b071949fbdd2823', 1),
(2, 'smtp.mailgun.org', 'postmaster@ls.org.ru', '81492cb0625bfe7358072596424c43cc', 1),
(3, 'smtp.mailgun.org', 'postmaster@lsboutique.ru', '999ac86e083e2823abefdf30ccaf7f99', 1),
(4, 'smtp.mailgun.org', 'postmaster@lstore.moscow', 'e7f6f67a006f568d14186228a88213a1', 1);


ALTER TABLE `emails` ADD `smtp` TINYINT UNSIGNED NOT NULL DEFAULT '0';