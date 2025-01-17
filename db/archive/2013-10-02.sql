ALTER TABLE  `products` ADD  `old_url` VARCHAR( 255 ) NOT NULL AFTER  `url`;
ALTER TABLE  `lsboutique`.`products` ADD INDEX  `old_url` (  `old_url` );