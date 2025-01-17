CREATE TABLE IF NOT EXISTS `products_shops` (
  `product_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  KEY `product_id` (`product_id`,`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
