CREATE TABLE `service_types` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `active` tinyint(3) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `service_types` (`id`, `name`, `active`) VALUES
(1, 'Химчистка', 1),
(2, 'Ателье', 1),
(3, 'Ремонт обуви', 1),
(4, 'Ремонт обуви МСК', 1);

ALTER TABLE `service_types`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `service_types`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

ALTER TABLE `services_orders_items` CHANGE `item_id` `service_type_id` INT(11) NOT NULL;

ALTER TABLE `services_orders_items` ADD `price` FLOAT(10) NOT NULL DEFAULT '0.00' AFTER `order_id`;
