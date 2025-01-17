ALTER TABLE  `users` ADD  `user_status` VARCHAR( 16 ) NOT NULL AFTER  `group_id`;
ALTER TABLE  `users` ADD  `p_manager_id` INT( 10 ) NOT NULL ,
ADD  `comment` VARCHAR( 255 ) NOT NULL;