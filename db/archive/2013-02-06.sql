CREATE TABLE `users2wishlist` (
`user_id` INT UNSIGNED NOT NULL ,
`product_id` INT UNSIGNED NOT NULL ,
`size` VARCHAR( 16 ) NOT NULL ,
`count` TINYINT NOT NULL
) ENGINE = MYISAM ;

ALTER TABLE `users2wishlist` ADD PRIMARY KEY ( `user_id` , `product_id` , `size` );