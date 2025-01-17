ALTER TABLE  `categories` CHANGE  `seo_words`  `seo_words` VARCHAR( 5000 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE  `brands` CHANGE  `seo_words`  `seo_words` VARCHAR( 5000 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

ALTER TABLE  `products` ADD  `seo_words` VARCHAR( 5000 ) NOT NULL AFTER  `guarantee`;
ALTER TABLE  `specials` ADD  `seo_words` TEXT NOT NULL AFTER  `url`;