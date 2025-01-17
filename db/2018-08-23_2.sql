CREATE TABLE IF NOT EXISTS `inkassators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `phone` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

INSERT INTO `inkassators` (`id`, `user_id`, `phone`) VALUES
(1, 4877, '79877536745'),
(2, 1330, '79202944697');
COMMIT;
