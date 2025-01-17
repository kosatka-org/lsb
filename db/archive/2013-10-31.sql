ALTER TABLE `users` ADD `purchase_sum_real` FLOAT( 10, 2 ) NOT NULL AFTER `purchase_sum`;

ALTER TABLE `users` ADD `purchase_last_what` VARCHAR( 255 ) NOT NULL AFTER `purchase_sum_real` ,
ADD `purchase_last_sum` FLOAT( 10, 2 ) NOT NULL AFTER `purchase_last_what` ,
ADD `purchase_last_date` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00' AFTER `purchase_last_sum`;

ALTER TABLE `users` CHANGE `purchase_sum` `purchase_sum` INT NOT NULL DEFAULT '0';
ALTER TABLE `users` CHANGE `purchase_sum_real` `purchase_sum_real` INT NOT NULL;
ALTER TABLE `users` CHANGE `purchase_last_sum` `purchase_last_sum` INT NOT NULL ;