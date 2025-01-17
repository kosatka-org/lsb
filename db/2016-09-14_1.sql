CREATE TABLE `items` (
  `item_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `barcode` varchar(50) NOT NULL,
  `size` varchar(30) NOT NULL,
  `normal_size` varchar(30) NOT NULL,
  `sweep` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `shop_id` (`shop_id`),
  ADD KEY `barcode` (`barcode`),
  ADD KEY `size` (`size`),
  ADD KEY `normal_size` (`normal_size`);


ALTER TABLE `items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

