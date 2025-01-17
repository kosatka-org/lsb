ALTER TABLE  `specials` ADD  `meta_title` VARCHAR( 500 ) NOT NULL AFTER  `description` ,
ADD  `meta_keywords` VARCHAR( 500 ) NOT NULL AFTER  `meta_title` ,
ADD  `meta_description` VARCHAR( 500 ) NOT NULL AFTER  `meta_keywords`
