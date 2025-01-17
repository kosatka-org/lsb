ALTER TABLE  `categories` ADD  `text_modified` DATETIME NOT NULL ,
ADD  `editor_id` INT( 8 ) NOT NULL;

ALTER TABLE  `brands` ADD  `text_modified` DATETIME NOT NULL ,
ADD  `editor_id` INT( 8 ) NOT NULL;