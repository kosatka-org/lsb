CREATE TABLE  `promo` (
`promo_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`name` VARCHAR( 200 ) NOT NULL ,
`date` VARCHAR( 200 ) NOT NULL ,
`brands` VARCHAR( 300 ) NOT NULL ,
`main_banner` VARCHAR( 300 ) NOT NULL ,
`product_banner` VARCHAR( 300 ) NOT NULL ,
`catalog_icon` VARCHAR( 300 ) NOT NULL ,
`promo_banner1` VARCHAR( 300 ) NOT NULL ,
`promo_banner2` VARCHAR( 300 ) NOT NULL ,
`promo_banner3` VARCHAR( 300 ) NOT NULL ,
`text` TEXT NOT NULL
) ENGINE = MYISAM CHARACTER SET utf8 COLLATE utf8_general_ci;

ALTER TABLE  `promo` ADD  `enabled` TINYINT( 1 ) NOT NULL AFTER  `promo_id`;