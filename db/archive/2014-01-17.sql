CREATE TABLE  `lsboutique`.`one_click` (
`id` INT NOT NULL AUTO_INCREMENT ,
`date` DATE NOT NULL ,
`name` VARCHAR( 255 ) NOT NULL ,
`phone` VARCHAR( 255 ) NOT NULL ,
`product_url` VARCHAR( 255 ) NOT NULL ,
`enabled` TINYINT NOT NULL ,
PRIMARY KEY (  `id` )
) ENGINE = MYISAM ;
ALTER TABLE  `one_click` CHANGE  `name`  `product_url` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE  `one_click` CHANGE  `phone`  `product_url` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE  `one_click` CHANGE  `product_url`  `product_url` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;