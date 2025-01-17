ALTER TABLE  `prodazhi` ADD  `enabled` TINYINT( 2 ) NOT NULL AFTER  `date`;
ALTER TABLE  `prodazhi` ADD  `url` VARCHAR( 500 ) NOT NULL AFTER  `enabled`;