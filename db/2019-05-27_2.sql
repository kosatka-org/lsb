CREATE TABLE `movement_types` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
INSERT INTO `movement_types` (`id`, `name`) VALUES
(1, 'На примерку'),
(2, 'На продажу'),
(3, 'Ателье'),
(4, 'Химчистка'),
(5, 'Обувная мастерская');
ALTER TABLE `movement_types`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `movement_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;