ALTER TABLE  `brands` ADD  `show_on_brandwall` TINYINT( 1 ) NOT NULL DEFAULT  '1',
ADD  `bigsize_on_brandwall` TINYINT( 1 ) NOT NULL DEFAULT  '0';

ALTER TABLE  `specials` ADD  `look_special` TINYINT( 1 ) NOT NULL DEFAULT  '0';