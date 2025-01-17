CREATE TABLE `fitting` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(250) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
INSERT INTO `fitting` (`id`, `name`, `description`) VALUES
(1, 'Regular (Classic) fit ', 'Крой такой модели прямой . Свободный.'),
(2, 'Slim fit', 'джинсы, сидящие точно по фигуре'),
(3, 'стрейч', 'эластичность за счет присутствия в составе материала эластичных синтетических нитей (эластан, спандекс или лайкра).');
ALTER TABLE `fitting`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `fitting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;
