CREATE TABLE `apple_pay_confirm` (
  `id` int(11) NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `md_order` varchar(150) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `status` varchar(150) NOT NULL,
  `date` timestamp NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `app_payments` (
  `id` tinyint(4) NOT NULL,
  `name` varchar(255) NOT NULL,
  `currencies` varchar(150) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `refund` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `app_payments` (`id`, `name`, `currencies`, `enabled`, `refund`) VALUES
(1, 'Сбербанк оплата', '', 1, 0),
(2, 'РФИ оплата', '', 1, 1),
(3, 'Apple pay', '', 1, 1);

ALTER TABLE `apple_pay_confirm` ADD PRIMARY KEY (`id`);
ALTER TABLE `app_payments` ADD PRIMARY KEY (`id`);
ALTER TABLE `apple_pay_confirm`  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
