ALTER TABLE  `ostatki` ADD  `url` VARCHAR( 255 ) NOT NULL AFTER  `sku`;
ALTER TABLE  `lsboutique`.`ostatki` ADD INDEX  `url` (  `url` );
ALTER TABLE  `ostatki` ADD  `material` VARCHAR( 255 ) NOT NULL;