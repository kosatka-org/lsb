CREATE TABLE  `luxurystore`.`products2sizes` (
`product_code` INT NOT NULL ,
`size` VARCHAR( 50 ) NOT NULL ,
INDEX (  `product_code` )
) ENGINE = MYISAM ;

ALTER TABLE  `luxurystore`.`products2sizes` ADD INDEX  `size` (  `size` )
