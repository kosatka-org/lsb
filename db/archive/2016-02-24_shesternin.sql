CREATE TABLE IF NOT EXISTS `rfi_transactions` (
  `tid` varchar(32) NOT NULL,
  `name` varchar(128) NOT NULL,
  `comment` text NOT NULL,
  `partner_id` varchar(32) NOT NULL,
  `service_id` varchar(32) NOT NULL,
  `order_id` varchar(16) NOT NULL,
  `type` varchar(4) NOT NULL,
  `partner_income` decimal(8,2) NOT NULL,
  `system_income` decimal(8,2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;