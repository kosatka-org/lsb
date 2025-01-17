ALTER TABLE `brands` ADD  `eng_text1` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `text38`,
ADD `eng_text2` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text1`,
ADD `eng_text4` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text2`,
ADD `eng_text38` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text4`;
ALTER TABLE `brands` ADD  `eng_text1_1` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `text38_1`,
ADD `eng_text2_1` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text1_1`,
ADD `eng_text4_1` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text2_1`,
ADD `eng_text38_1` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text4_1`;
ALTER TABLE `brands` ADD  `eng_text1_2` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `text38_2`,
ADD `eng_text2_2` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text1_2`,
ADD `eng_text4_2` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text2_2`,
ADD `eng_text38_2` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `eng_text4_2`;