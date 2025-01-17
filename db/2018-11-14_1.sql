CREATE TABLE `online_payments` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount` float(10,2) NOT NULL,
  `paid` tinyint(1) NOT NULL,
  `sb_tran_id` int(11) NOT NULL,
  `hash` varchar(150) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE `online_payments`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `online_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
