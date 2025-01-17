UPDATE `cities` SET city_id = ( SELECT city_id FROM delivery_cities dc WHERE dc.city_name = name AND country_id =209 LIMIT 1 );

ALTER TABLE `cities` ADD `image_right` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' AFTER `image`;