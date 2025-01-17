ALTER TABLE  `brands` ADD  `gender` INT( 4 ) NOT NULL AFTER  `url`;
ALTER TABLE  `brands` ADD  `seo_words` VARCHAR( 255 ) NOT NULL AFTER  `meta_description`;
ALTER TABLE  `categories` ADD  `gender` INT( 4 ) NOT NULL AFTER  `url`;
ALTER TABLE  `categories` ADD  `seo_words` VARCHAR( 255 ) NOT NULL AFTER  `meta_description`;