CREATE TABLE IF NOT EXISTS `adv_video` (
  `id` int(11) NOT NULL,
  `video` varchar(100) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `adv_video` (`id`, `video`, `date`) VALUES
(0, '', '0000-00-00 00:00:00'),
(1, '', '0000-00-00 00:00:00'),
(2, '', '0000-00-00 00:00:00'),
(3, '', '0000-00-00 00:00:00');