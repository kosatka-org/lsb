CREATE TABLE `sizetables` (
`sizetable_id` INT( 16 ) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`XXS` INT( 8 ) NOT NULL ,
`XS` INT( 8 ) NOT NULL ,
`S` INT( 8 ) NOT NULL ,
`M` INT( 8 ) NOT NULL ,
`L` INT( 8 ) NOT NULL ,
`XL` INT( 8 ) NOT NULL ,
`XXL` INT( 8 ) NOT NULL,
`XXXL` INT( 8 ) NOT NULL,
`XXXXL` INT( 8 ) NOT NULL
) ENGINE = MYISAM ;

ALTER TABLE `products2sizes` ADD `normal_size` VARCHAR( 16 ) NOT NULL;

CREATE TABLE `cats2sizetables` (
`sex` INT( 8 ) NOT NULL ,
`category_id` INT( 8 ) NOT NULL ,
`brand_id` INT( 8 ) NOT NULL ,
`sizetable_id` INT( 8 ) NOT NULL
) ENGINE = MYISAM ;

