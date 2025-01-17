CREATE TABLE `materials_stretch` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `stretch` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
INSERT INTO `materials_stretch` (`id`, `name`, `stretch`) VALUES
(1, 'Не эластичный', '0 -10'),
(2, 'Нормальный', '-5 +5'),
(3, 'Не эластичный', '-10 0');
ALTER TABLE `materials_stretch`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `materials_stretch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;
