ALTER TABLE `service_types` ADD `eng_name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `name`;
UPDATE `service_types` SET `eng_name` = 'Dry Cleaning' WHERE `id` = 1;
UPDATE `service_types` SET `eng_name` = 'Atelier' WHERE `id` = 2;
UPDATE `service_types` SET `eng_name` = 'Shoe repair' WHERE `id` = 3;
UPDATE `service_types` SET `eng_name` = 'Shoe repair Moskow' WHERE `id` = 4;

ALTER TABLE `services_orders_items` ADD `status_eng` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `status`;
UPDATE `services_orders_items` SET `status_eng`='Accepted' WHERE `status` = 'Принято';
UPDATE `services_orders_items` SET `status_eng`='In process' WHERE `status` = 'В работе';
UPDATE `services_orders_items` SET `status_eng`='At boutique, ready' WHERE `status` = 'В бутике, ждет клиента';
UPDATE `services_orders_items` SET `status_eng`='Returned to client' WHERE `status` = 'Выдано клиенту';