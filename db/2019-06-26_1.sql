ALTER TABLE `shop_cashbox` ADD `code_1s` VARCHAR(255) NOT NULL AFTER `device_uuid`, ADD `imei` VARCHAR(255) NOT NULL AFTER `code_1s`;
