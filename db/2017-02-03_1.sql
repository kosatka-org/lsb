ALTER TABLE `payment_offline` ADD `return` TINYINT(1) NOT NULL AFTER `enabled`;

INSERT INTO `payment_offline` (`id`, `name`, `enabled`, `return`) VALUES (NULL, 'Возврат наличными', '1', '1'), (NULL, 'Возврат на карту', '1', '1');
