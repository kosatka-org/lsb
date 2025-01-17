ALTER TABLE  `users` ADD  `need_welcome_email` TINYINT UNSIGNED NOT NULL AFTER  `email`;


CREATE TABLE  `users2brands` (
`user_id` INT UNSIGNED NOT NULL ,
`brand_id` TINYINT UNSIGNED NOT NULL ,
`status` TINYINT UNSIGNED NOT NULL DEFAULT  '1',
`date_updated` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = MYISAM ;


ALTER TABLE  `users2brands` ADD PRIMARY KEY (  `user_id` ,  `brand_id` ) ;

ALTER TABLE `users` ADD `original_user_id` INT UNSIGNED NOT NULL DEFAULT '0' AFTER `user_id`;

UPDATE users SET original_user_id = user_id WHERE original_user_id = '0'

ALTER TABLE `users` ADD `network` VARCHAR( 255 ) NOT NULL AFTER `email` ,
ADD `identity` VARCHAR( 255 ) NOT NULL AFTER `network`;