CREATE TABLE `offline_sales_person` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `cashbox_ids` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `offline_sales_person` (`id`, `cashbox_ids`, `name`) VALUES
(1, '0,1,2,3,4,5,6,7,8,9,10,11,', 'Жехарев'),
(2, '0,1,2,3,4,', 'Вольпер'),
(3, '0,1,2,3,4,', 'Чюрюм'),
(4, '0,1,2,3,4,', 'Павлова'),
(5, '0,6,', 'Шимак'),
(6, '0,6,', 'Тарасова'),
(10, '0,12,', 'Жукова'),
(7, '0,5,', 'Яхтина'),
(8, '0,5,', 'Хаширова'),
(9, '0,12,', 'Жехарева'),
(11, '0,12,', 'Баранова'),
(12, '0,7,8,9,10,11,', 'Востик'),
(13, '0,7,8,9,10,11,', 'Чермошенцева'),
(14, '0,7,8,9,10,11,', 'Бахтева');

ALTER TABLE `offline_sales_person`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `offline_sales_person`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
