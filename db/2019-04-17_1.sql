CREATE TABLE IF NOT EXISTS `networks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `keyword` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `app_keys` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
INSERT INTO `networks` (`id`, `name`, `keyword`, `app_keys`, `active`) VALUES
(1, 'Почта mail.ru', 'mailru', 'mail_login_client_id', 1),
(2, 'Яндекс', 'yandex', 'yandex_login_client_id', 1),
(3, 'вКонтакте', 'vkontakte', 'vk_login_client_id', 1);
