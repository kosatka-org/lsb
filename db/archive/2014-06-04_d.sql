ALTER TABLE  `categories` ADD  `mens_description` TEXT NOT NULL AFTER  `description` ,
ADD  `womens_description` TEXT NOT NULL AFTER  `mens_description`;

ALTER TABLE  `categories` ADD  `text2_modified` DATETIME NOT NULL AFTER  `text_modified` ,
ADD  `text3_modified` DATETIME NOT NULL AFTER  `text2_modified`;