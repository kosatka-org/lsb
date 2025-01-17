CREATE TABLE `TK_ip` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `key1` varchar(250) NOT NULL,
  `key2` varchar(250) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `TK_ip` (`id`, `company_id`, `name`, `key1`, `key2`) VALUES
(1, 5, 'СДЕК Жехарев ЕВ', 'e7de5474a171f56230dba483d003527d', '057e391eeeb581c58c6811dd51958465'),
(2, 5, 'СДЕК Жехарева ЕН', '4afe64f63986304f089e68ad36cc8549', '08b5b44c24f131d3a0136478195ccfdb'),
(3, 5, 'СДЕК Жехарев ВН', '92f459b91b081285bd76b2d3c331ec0f', '21ac98c55453112fcc297a13e2573e37');

ALTER TABLE `TK_ip`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `TK_ip`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

