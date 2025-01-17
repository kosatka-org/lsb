CREATE TABLE IF NOT EXISTS `s_materials` (
`material_id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
`image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
`description` text NOT NULL,
`aliases` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
PRIMARY KEY (`material_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
ALTER TABLE  `products` ADD  `s_material` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;