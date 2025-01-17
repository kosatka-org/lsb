ALTER TABLE  `sets` ADD  `main_product_id` INT( 16 ) NULL AFTER  `id` ,
ADD INDEX (  `main_product_id` ) ;

ALTER TABLE  `sets` ADD  `image` VARCHAR( 255 ) NOT NULL ;