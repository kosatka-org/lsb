ALTER TABLE  `orders` ADD  `coupon_discount` DECIMAL( 9, 2 ) NOT NULL AFTER  `payment_date`;
ALTER TABLE  `orders` ADD  `coupon_type` enum('absolute','percentage') NOT NULL AFTER  `coupon_discount`;
ALTER TABLE  `orders` ADD  `coupon_code` varchar(16) NOT NULL AFTER  `coupon_type`;

CREATE TABLE IF NOT EXISTS `coupons` (
  `id` int(7) NOT NULL AUTO_INCREMENT,
  `code` varchar(16) NOT NULL,
  `date_start` date NOT NULL,
  `date_finish` date NOT NULL,
  `value` decimal(9,2) NOT NULL,
  `type` enum('absolute','percentage') NOT NULL,
  `num_uses` int(5) NOT NULL,
  `uses` int(5) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;