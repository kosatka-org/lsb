ALTER TABLE `brands` ADD `eng_description` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `description`;
ALTER TABLE `brands` ADD `eng_description_m` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `description_m`;
ALTER TABLE `brands` ADD `eng_description_w` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `description_w`;
ALTER TABLE `brands` ADD `eng_description_looks` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `description_looks`;
