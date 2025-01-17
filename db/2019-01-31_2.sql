CREATE TABLE `bookmarks` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `bookmarks` (`id`, `name`) VALUES
(1, 'Админка'),
(2, 'Админка - ТК'),
(3, 'Админка - Бухгалтерия'),
(4, 'Админка - Звонки'),
(5, 'Кабинет менеджера'),
(6, 'Сообщить об ошибке'),
(7, 'Информация о клиенте'),
(8, 'Добавить услугу'),
(9, 'Панель кассира'),
(10, 'Список перемещений'),
(11, 'Список отложка'),
(12, 'Панель задолженностей'),
(13, 'Панель возвратов'),
(14, 'Индивидуальный пошив'),
(15, 'Панель обзвонов'),
(16, 'Заказ услуг'),
(17, 'Прием первички'),
(18, 'Список продаж');
ALTER TABLE `bookmarks`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `bookmarks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;