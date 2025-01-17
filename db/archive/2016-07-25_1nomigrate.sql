ALTER TABLE  `products` CHANGE  `tsum_sku`  `tsum_url` VARCHAR( 200 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ;

UPDATE `products` SET `tsum_url` = '' WHERE 1;
