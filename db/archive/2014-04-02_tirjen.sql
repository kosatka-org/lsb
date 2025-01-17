// Прописываем поля правильно, не забываем DEFAULT и знаки UNSIGNED
ALTER TABLE `users` ADD `deposit` INT( 8 ) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'количество денег у пользователя на депозите' AFTER `uid` 

CREATE TABLE IF NOT EXISTS `deposit_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `admin_id` int(6) unsigned NOT NULL COMMENT 'человек давший депозит',
  `user_id` int(6) unsigned NOT NULL DEFAULT '0' COMMENT 'получатель депозита',
  `record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sum` int(8) NOT NULL COMMENT 'сумма изменения депозита в рублях',
  `reason` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

ALTER TABLE `orders` ADD deposit_payment INT( 8 ) UNSIGNED NOT NULL DEFAULT '0'