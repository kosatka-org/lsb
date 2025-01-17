ALTER TABLE `movements` ADD `reservation_date` DATE NOT NULL AFTER `need_confirmation`, ADD `responsible` VARCHAR(100) NOT NULL AFTER `reservation_date`;
