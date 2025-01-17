ALTER TABLE  `brands` ADD  `hidden` TINYINT NOT NULL DEFAULT  '0';
ALTER TABLE  `users` ADD  `show_hidden_brands` VARCHAR( 50 ) NOT NULL ;

CREATE TABLE IF NOT EXISTS `sets` (
  `id` int(16) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `sets_products` (
  `set_id` int(16) NOT NULL,
  `product_id` int(16) NOT NULL,
  UNIQUE KEY `set_id` (`set_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;