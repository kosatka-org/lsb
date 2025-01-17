ALTER TABLE `users_calls` ADD `stat_total` INT UNSIGNED NOT NULL ,
ADD `stat_called` INT UNSIGNED NOT NULL ,
ADD `stat_missing` INT UNSIGNED NOT NULL ,
ADD `stat_sms` INT UNSIGNED NOT NULL;

ALTER TABLE `users_calls` ADD `status` TINYINT UNSIGNED NOT NULL DEFAULT '1' AFTER `id`;

ALTER TABLE  `ostatki` ADD  `category_id` INT( 16 ) NOT NULL AFTER  `category_name` ,
ADD  `brand_id` INT( 16 ) NOT NULL AFTER  `category_id`