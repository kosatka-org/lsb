CREATE TABLE IF NOT EXISTS `ostatki` (
  `code` int(16) NOT NULL COMMENT 'Код',
  `sku` varchar(256) NOT NULL COMMENT 'Артикул',
  `model` varchar(256) NOT NULL COMMENT 'Наименование',
  `sex` varchar(256) NOT NULL COMMENT 'Пол',
  `season` varchar(256) NOT NULL COMMENT 'Сезон',
  `brand` varchar(256) NOT NULL COMMENT 'Бренд',
  `location` varchar(256) NOT NULL COMMENT 'Склад',
  `nomenk_group` varchar(256) NOT NULL COMMENT 'Номенклатурная группа',
  `harakteristika_nomenk` varchar(256) NOT NULL COMMENT 'Характеристика номенклатуры',
  `quantity` int(16) NOT NULL COMMENT 'Количество',
  `purchase_sum` varchar(256) NOT NULL COMMENT 'Сумма закупки',
  `retail_price` varchar(256) NOT NULL COMMENT 'Розничная стоимость',
  `size` varchar(256) NOT NULL COMMENT 'Размер',
  `color` varchar(256) NOT NULL COMMENT 'Цвет'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `prodazhi` (
  `date` varchar(256) NOT NULL COMMENT 'Дата',
  `card` varchar(256) NOT NULL COMMENT 'Карта',
  `sum_without_discount` varchar(256) NOT NULL COMMENT 'Сумма без скидки',
  `sum_with_discount` varchar(256) NOT NULL COMMENT 'Сумма со скидкой',
  `discount` varchar(256) NOT NULL COMMENT 'Процент скидки',
  `client` varchar(256) NOT NULL COMMENT 'Клиент',
  `original_user_id` varchar(256) NOT NULL COMMENT 'original_user_id',
  `code` int(16) NOT NULL COMMENT 'Код',
  `sku` varchar(256) NOT NULL COMMENT 'Артикул',
  `model` varchar(256) NOT NULL COMMENT 'Наименование',
  `sex` varchar(256) NOT NULL COMMENT 'Пол',
  `season` varchar(256) NOT NULL COMMENT 'Сезон',
  `brand` varchar(256) NOT NULL COMMENT 'Бренд',
  `location` varchar(256) NOT NULL COMMENT 'Склад',
  `nomenk_group` varchar(256) NOT NULL COMMENT 'Номенклатурная группа',
  `harakteristika_nomenk` varchar(256) NOT NULL COMMENT 'Характеристика номенклатуры',
  `quantity` int(16) NOT NULL COMMENT 'Количество',
  `purchase_sum` varchar(256) NOT NULL COMMENT 'Сумма закупки',
  `retail_price` varchar(256) NOT NULL COMMENT 'Розничная стоимость',
  `size` varchar(256) NOT NULL COMMENT 'Размер',
  `color` varchar(256) NOT NULL COMMENT 'Цвет'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


ALTER TABLE `prodazhi` ADD `p_date` TIMESTAMP NOT NULL AFTER `date`;
ALTER TABLE `prodazhi` ADD `p_sum_without_discount` DECIMAL( 8, 2 ) NOT NULL AFTER `sum_without_discount`;
ALTER TABLE `prodazhi` ADD `p_sum_with_discount` DECIMAL( 8, 2 ) NOT NULL AFTER `sum_with_discount`;
ALTER TABLE `prodazhi` ADD `p_discount` DECIMAL( 8, 2 ) NOT NULL AFTER `discount`;
ALTER TABLE `prodazhi` ADD `p_location` VARCHAR( 32 ) NOT NULL AFTER `location`;
ALTER TABLE `prodazhi` ADD `p_season`   VARCHAR( 32 ) NOT NULL AFTER `season`;


UPDATE `prodazhi` SET `p_sum_without_discount` = REPLACE(REPLACE(`sum_without_discount`, ' ', ''), ',', '.');
UPDATE `prodazhi` SET `p_sum_with_discount` = REPLACE(REPLACE(`sum_with_discount`, ' ', ''), ',', '.');

UPDATE `prodazhi` SET `p_discount` = REPLACE(REPLACE(`discount`, ' ', ''), ',', '.');

UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`season`, ' main', ''), ' pre', ''), ' sfilata', ''), ' обувь', ''), ' НН', ''), ' MF', '');
UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, ' V', ''), ' P', ''), ' C', ''), ' W', ''), ' AB', ''), ' AR', '');
UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, ' k', ''), ' LF', ''), ' T', ''), ' T', ''), '/1A', '/1'), '<>', ''), ' E', '');
UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, 'CORNELIANI', ''), 'ISAIA', ''), 'Kiton', ''), 'Versace', ''), 'Сезон', ''), 'реализ', '');
UPDATE `prodazhi` SET `p_season` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(`p_season`, 'MTM', ''), ' ICE Iceberg', ''), ' Iceberg', ''), 'D', ''), 'Сезон', ''), 'U/D', ''), 'Брй', ''), 'U/', ''), 'U', '');

UPDATE `prodazhi` SET `p_location` = REPLACE(REPLACE(REPLACE(`location`, ' опт', ''), ' (Республика)', ''), 'Сток', 'Склад');


ALTER TABLE `prodazhi` ADD INDEX ( `date` );
ALTER TABLE `prodazhi` ADD `p_date` TIMESTAMP NOT NULL AFTER `date`;
ALTER TABLE  `prodazhi` DROP  `purchase_sum`;
ALTER TABLE  `prodazhi` DROP  `retail_price`

