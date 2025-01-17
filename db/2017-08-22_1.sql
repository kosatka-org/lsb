ALTER TABLE `products`
  DROP `guarantee`,
  DROP `hit`,
  DROP `pack_id`,
  DROP `download`;

ALTER TABLE `products` ADD `season_type` VARCHAR(20) NOT NULL DEFAULT 'new_season' AFTER `season`;

ALTER TABLE `products` ADD `last_price_online` FLOAT(10,2) NOT NULL AFTER `last_price`;
