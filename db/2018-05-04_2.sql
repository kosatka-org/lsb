ALTER TABLE  `users` ADD  `language` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE  `categories` ADD  `eng_name` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER  `single_name` ,
ADD  `eng_single_name` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER  `eng_name`;
ALTER TABLE  `s_materials` ADD  `eng_name` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER  `name`;
ALTER TABLE  `products` ADD  `eng_text_sizes` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER  `text_sizes`;
ALTER TABLE  `specials` ADD  `eng_name` VARCHAR( 256 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER  `name`;
