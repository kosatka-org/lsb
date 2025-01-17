ALTER TABLE `prodazhi` ADD INDEX ( `p_location` );

ALTER TABLE `prodazhi` ADD INDEX ( `brand` );

ALTER TABLE ostatki ADD INDEX ( `p_location` );

ALTER TABLE `ostatki` ADD INDEX ( `brand` );



ALTER TABLE  `prodazhi` ADD  `p_sex` VARCHAR( 24 ) NOT NULL AFTER  `sex`;

ALTER TABLE  `ostatki` ADD  `p_sex` VARCHAR( 24 ) NOT NULL AFTER  `sex`;