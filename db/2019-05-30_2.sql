CREATE TABLE `items_measuring_pants` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `waist` varchar(50) NOT NULL COMMENT 'замер по талии',
  `hips` varchar(50) NOT NULL COMMENT 'замер по  бедрам',
  `thigh` varchar(50) NOT NULL COMMENT 'замер по ширине ляжки',
  `waist_height` varchar(50) NOT NULL COMMENT 'высота посадки',
  `bottom_width` varchar(50) NOT NULL COMMENT 'замер низа брючины',
  `knee_width` varchar(50) NOT NULL COMMENT 'замер колена (для спортивных брюк)',
  `leg_lenght` varchar(50) NOT NULL COMMENT 'замер длины брючины'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
CREATE TABLE `items_measuring_tops` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `shoulders` varchar(50) NOT NULL COMMENT 'Замер по плечам',
  `chest` varchar(50) NOT NULL COMMENT 'Замер объема груди',
  `waist` varchar(50) NOT NULL COMMENT 'Замер по талии',
  `lenght_on_back` varchar(50) NOT NULL COMMENT 'Длина изделия по спине',
  `sleeve` varchar(50) NOT NULL COMMENT 'Замер длины рукава изделия',
  `bottom_band` varchar(50) NOT NULL COMMENT 'Замер резинки внизу изделия (если присутствует)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE `items_measuring_pants`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `items_measuring_tops`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `items_measuring_pants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `items_measuring_tops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
