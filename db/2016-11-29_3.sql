ALTER TABLE `orders_payments` ADD `debt_paid_off` tinyint(1) NOT NULL DEFAULT '0';
ALTER TABLE `orders_payments` ADD `date` timestamp NOT NULL;
