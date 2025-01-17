CREATE TABLE `delivery_cities` (
`city_id` INT UNSIGNED NOT NULL ,
`city_owner_id` INT UNSIGNED NOT NULL ,
`city_name` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`region_id` INT UNSIGNED NOT NULL ,
`region_owner_id` INT UNSIGNED NOT NULL ,
`region_name` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`country_id` INT UNSIGNED NOT NULL ,
`country_owner_id` INT UNSIGNED NOT NULL ,
`country_name` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
PRIMARY KEY ( `city_id` )
) ENGINE = MYISAM ;