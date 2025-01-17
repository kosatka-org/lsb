ALTER TABLE  `categories` ADD  `canonical_id` INT( 11 ) NULL DEFAULT NULL ,
ADD INDEX (  `canonical_id` ) ;