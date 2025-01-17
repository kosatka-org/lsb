CREATE TABLE IF NOT EXISTS `special_orders` (
  `so_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `user_name` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_phone` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_email` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `manager_id` int(11),
  `product_id` int(11) NOT NULL,
  `product_size` VARCHAR( 20 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `order_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`so_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;