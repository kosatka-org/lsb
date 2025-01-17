ALTER TABLE `one_click` ADD `cr_manager` INT( 16 ) NOT NULL;
ALTER TABLE `one_click` ADD `ga_client_id` VARCHAR( 32 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

ALTER TABLE `orders` ADD `cr_manager` INT( 16 ) NOT NULL;
ALTER TABLE `orders` ADD `ga_client_id` VARCHAR( 32 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

ALTER TABLE `special_orders` ADD `cr_manager` INT( 16 ) NOT NULL;
ALTER TABLE `special_orders` ADD `ga_client_id` VARCHAR( 32 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;