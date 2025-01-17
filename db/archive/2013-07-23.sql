ALTER TABLE `ostatki` ADD `p_retail_price` DECIMAL( 8, 2 ) NOT NULL AFTER `retail_price`;

ALTER TABLE `ostatki` ADD `p_purchase_sum` DECIMAL( 8, 2 ) NOT NULL AFTER `purchase_sum`;

ALTER TABLE `ostatki` ADD `p_location` VARCHAR( 32 ) NOT NULL AFTER `location`;

ALTER TABLE `ostatki` ADD `p_season` VARCHAR( 16 ) NOT NULL AFTER `season`;