ALTER TABLE  `products` ADD  `bsize_small_image` VARCHAR( 255 ) NOT NULL AFTER  `large_image` ,
ADD  `bsize_large_image` VARCHAR( 255 ) NOT NULL AFTER  `bsize_small_image` ;

ALTER TABLE  `products_fotos` ADD  `big_size` TINYINT( 1 ) NOT NULL DEFAULT  '0';

ALTER TABLE  `sets` ADD  `big_size` TINYINT( 1 ) NOT NULL DEFAULT  '0';
