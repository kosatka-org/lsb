CREATE TABLE `users_measuring` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `fitting` varchar(25) NOT NULL,
  `stretch` varchar(25) NOT NULL,
  `shoulders` int(11) NOT NULL COMMENT 'Замер по плечам',
  `chest` int(11) NOT NULL COMMENT 'Замер объема груди',
  `lenght_on_back` int(11) NOT NULL COMMENT 'Длина изделия по спине',
  `sleeve` int(11) NOT NULL COMMENT 'Замер длины рукава изделия',
  `bottom_band` int(11) NOT NULL COMMENT 'Замер резинки внизу изделия (если присутствует)',
  `waist` int(11) NOT NULL COMMENT 'замер по талии',
  `hips` int(11) NOT NULL COMMENT 'замер по бедрам',
  `thigh` int(11) NOT NULL COMMENT 'замер по ширине ляжки',
  `waist_height` int(11) NOT NULL COMMENT 'высота посадки',
  `bottom_width` int(11) NOT NULL COMMENT 'замер низа брючины',
  `knee_width` int(11) NOT NULL COMMENT 'замер колена (для спортивных брюк)',
  `leg_lenght` int(11) NOT NULL COMMENT 'замер длины брючины'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE `users_measuring`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `users_measuring`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;