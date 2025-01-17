ALTER TABLE `orders_payments` ADD `cashbox_id` INT(12) NOT NULL AFTER `date`, ADD `responsible_person_id` INT(12) NOT NULL AFTER `cashbox_id`;
