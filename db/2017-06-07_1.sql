CREATE TABLE `services_items` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `price` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `type` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `services_items` (`id`, `name`, `price`, `time`, `type`) VALUES
(1, 'Брюки длина', 500, 30, 'atelier'),
(2, 'Брюки заузить', 800, 60, 'atelier'),
(3, 'Брюки убрать в об.т. (ср. шов)', 1200, 90, 'atelier'),
(4, 'Брюки опустить в поясе', 3200, 240, 'atelier'),
(5, 'Джинсы длина', 500, 30, 'atelier'),
(6, 'Джинсы длина с повтором', 800, 60, 'atelier'),
(7, 'Джинсы заузить', 1200, 90, 'atelier'),
(8, 'Джинсы убрать в об.т. (ср. шов)', 1200, 90, 'atelier'),
(9, 'Джинсы опустить в поясе', 3200, 240, 'atelier'),
(10, 'Рубашка/трикотаж заузить', 800, 60, 'atelier'),
(11, 'Рубашка/трикотаж длина изделия', 1200, 90, 'atelier'),
(12, 'Рубашка/трикотаж длина рукава', 800, 60, 'atelier'),
(13, 'Рубашка/трикотаж длина рукава с планкой', 1600, 120, 'atelier'),
(14, 'Рубашка/трикотаж заузить рукав', 1200, 90, 'atelier'),
(15, 'Пиджак петли', 2400, 120, 'atelier'),
(16, 'Пиджак длина изделия', 3200, 240, 'atelier'),
(17, 'Пиджак длина рукава низом', 1600, 120, 'atelier'),
(18, 'Пиджак длина рукава окатом', 3200, 240, 'atelier'),
(19, 'Пиджак заузить/расст. по ср. ш.', 800, 60, 'atelier'),
(20, 'Пиджак заузить/расст. 3 шва', 2400, 180, 'atelier'),
(21, 'Пиджак росток', 1200, 90, 'atelier'),
(22, 'Пиджак стянуть лацкан', 800, 60, 'atelier'),
(23, 'Пиджак ВТО', 800, 60, 'atelier'),
(24, 'Платье заузить в бедрах', 1000, 60, 'atelier'),
(25, 'Платье заузить целиком', 2000, 120, 'atelier'),
(26, 'Платье длина', 1000, 60, 'atelier'),
(27, 'Ремень обрезать', 600, 30, 'atelier'),
(28, 'Обувная матерская - проф-ка', 1500, 0, 'shoes'),
(29, 'Обувная матерская - полная проф-ка', 2500, 0, 'shoes'),
(30, 'Обувная матерская - восстановление', 1500, 0, 'shoes'),
(31, 'Обувная мастерская - набойки жен', 1000, 0, 'shoes'),
(32, 'Обувная мастерская - набойки муж', 1500, 0, 'shoes'),
(33, 'Обувная мастерская - растяжка', 1000, 0, 'shoes'),
(34, 'Обувная мастерская - шнурки (резинки)', 1500, 0, 'shoes'),
(35, 'Х/Ч - рубашка', 600, 0, 'clean'),
(36, 'Х/Ч - брюки/джинсы', 700, 0, 'clean'),
(37, 'Х/Ч - трикотаж (тонкий)', 700, 0, 'clean'),
(38, 'Х/Ч - трикотаж (плотный)', 900, 0, 'clean'),
(39, 'Х/Ч - костюм', 2000, 0, 'clean'),
(40, 'Х/Ч - пиджак', 1500, 0, 'clean'),
(41, 'Х/Ч - платье', 1500, 0, 'clean'),
(42, 'Х/Ч - юбка', 800, 0, 'clean'),
(43, 'Х/Ч - блузка', 700, 0, 'clean'),
(44, 'Х/Ч - куртка без меха', 2500, 0, 'clean'),
(45, 'Х/Ч - куртка с мехом', 3500, 0, 'clean');

ALTER TABLE `services_items`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `services_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

CREATE TABLE `services_orders` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `client_id` int(20) NOT NULL,
  `client_info` varchar(300) NOT NULL,
  `comment` varchar(500) NOT NULL,
  `real_order_id` int(11) NOT NULL,
  `item_name` varchar(200) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE `services_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `real_order_id` (`real_order_id`);

ALTER TABLE `services_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

CREATE TABLE `services_orders_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `status` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE `services_orders_items`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `services_orders_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;
