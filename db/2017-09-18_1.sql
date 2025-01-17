ALTER TABLE `inkass` ADD `shop_id` INT NOT NULL AFTER `responsible_user_id`;

ALTER TABLE `expenses` ADD `shop_id` INT NOT NULL AFTER `user_id`;
