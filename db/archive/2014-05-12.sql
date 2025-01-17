ALTER TABLE `orders` ADD `payment_prepaid` DECIMAL( 8, 2 ) NOT NULL DEFAULT '0' COMMENT 'Предоплаченная сумма за заказ' AFTER `invoice_number`;

ALTER TABLE `orders` CHANGE `payment_method_id` `payment_method_id` INT( 3 ) NULL DEFAULT '12'