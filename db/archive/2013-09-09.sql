ALTER TABLE `orders` ADD `delivery_company_id` TINYINT UNSIGNED NOT NULL DEFAULT '0' AFTER `delivery_method_id`;


DROP TABLE IF EXISTS `delivery_companies`;
CREATE TABLE IF NOT EXISTS `delivery_companies` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Id представителя компании',
  `name` varchar(255) NOT NULL,
  `address` tinytext NOT NULL,
  `logo` varchar(255) NOT NULL,
  `dogovor_number` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

INSERT INTO `delivery_companies` (`id`, `user_id`, `name`, `address`, `logo`, `dogovor_number`, `email`, `active`) VALUES
(1, 0, 'ООО "СПСР-Экспресс"', '					109316 Россия, Москва,\r\nВолгоградский пр-т, д. 42, корп. 23\r\n(800) 555-5445; (495) 981-10-10\r\n<a href="www.spsr.ru" target="_blank">www.spsr.ru</a>', '<img src="/images/spsr_logo.png" width="131" height="131" />', '5200346811', 'megacuba@gmail.com', 1),
(2, 0, 'ООО "Центр-доставки"', '', '', '5200346812', 'shesternin@gmail.com', 1);
