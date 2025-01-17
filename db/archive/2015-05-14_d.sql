ALTER TABLE  `one_click` ADD  `user_id` INT( 16 ) NULL DEFAULT NULL AFTER  `id` ,
ADD INDEX (  `user_id` ) ;
