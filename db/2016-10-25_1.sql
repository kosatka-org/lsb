ALTER TABLE `shop_cashbox` ADD `entity` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' AFTER `name`;

ALTER TABLE `shop_cashbox` ADD `inn` VARCHAR(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' AFTER `entity`, ADD `address` VARCHAR(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' AFTER `inn`;

ALTER TABLE `shop_cashbox` ADD `description` VARCHAR(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' AFTER `name`;
ALTER TABLE `shop_cashbox` CHANGE `name` `name` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

INSERT INTO `payment_offline` (`id`, `name`, `enabled`) VALUES (NULL, 'Сертификат', '1');

DELETE FROM `shop_cashbox` WHERE id = 1;

INSERT INTO `shop_cashbox` (`id`, `name`, `description`, `entity`, `inn`, `address`, `shop_id`, `payments_ids`, `enabled`) VALUES
(1, 'Касса1, НВН', 'залы: Zilli, Dior, Saint Laurent', 'ИП Жехарева ЕН', '526015264740', 'г.Нижний Новгород, Нижне-Волжская набережная, 8/7', 0, '1,2,3,4,5', 1),
(2, 'Касса2, НВН', 'залы: Dolce Gabana, мульти брендовый муж.', 'ИП Жехарев ВН', '525709427782', 'г.Нижний Новгород, Нижне-Волжская набережная, 8/7', 0, '1,3,4,5', 1),
(3, 'Касса3, НВН', 'залы: Celine, A.Testoni, Kiton, Artioli, мульти брендовый жен.', 'ИП Жехарев ЕВ', '526054606726', 'г. Нижний Новгород, ул. Большая Покровская, 50/12', 0, '1,3,4,5', 1),
(4, 'Касса4, НВН', 'залы: Loro Piana, Billionaire, Berluti', 'ИП Жехарев ИВ', '526003230948', 'г.Нижний Новгород, Нижне-Волжская набережная, 8/7', 0, '1,3,4,5', 1),
(5, 'Iceberg', '', 'ИП Жехарева ЕН', '526015264740', 'г.Нижний Новгород, ул.Алексеевская, 10/16', 0, '1,3,4,5', 1),
(6, 'Ramsei', '', 'ИП Жехарев ВН', '525709427782', 'г. Нижний Новгород, ул. Большая Покровская, 10', 0, '1,3,4,5', 1),
(7, 'Касса1, этаж 1, Покровка 50', '', 'ИП Жехарев ЕВ', '526054606726', 'г. Нижний Новгород, ул. Большая Покровская, 50/12', 0, '1,3,4,5', 1),
(8, 'Касса2, этаж 1, Покровка 50', '', 'ИП Казачкова АС', '525406740178', 'г. Нижний Новгород, ул. Большая Покровская, 50/12', 0, '1,3,4,5', 1),
(9, 'Касса1, этаж 2, Покровка 50', '', 'ИП Жехарева ЕН', '526015264740', 'г. Нижний Новгород, ул. Большая Покровская, 50/12', 0, '1,3,4,5', 1),
(10, 'Касса2, этаж 2, Покровка 50', '', 'ИП Жехарев ЕВ', '526054606726', 'г. Нижний Новгород, ул. Большая Покровская, 50/12', 0, '1,3,4,5', 1),
(11, 'Касса1, этаж 3, Покровка 50', '', 'ИП Жехарев ИВ', '526003230948', 'г. Нижний Новгород, ул. Большая Покровская, 50/12', 0, '1,3,4,5', 1),
(12, 'Подиум VIP', '', 'ИП Жехарева ЕН', '526015264740', 'г.Нижний Новгород, ул.Алексеевская, 10/16', 0, '1,3,4,5', 1);
