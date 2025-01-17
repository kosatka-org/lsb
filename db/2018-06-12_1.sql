ALTER TABLE  `products` ADD  `eng_body` LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER  `body`;
ALTER TABLE  `products` ADD  `eng_description` LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER  `description`;
ALTER TABLE  `products` ADD  `eng_uhod` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER  `uhod`;