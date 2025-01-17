ALTER TABLE `users` ADD `cashbox_ids` VARCHAR(20) NOT NULL COMMENT 'Id кассы к которым прикреплен аккаунт менеджера-кассира';

ALTER TABLE `users` DROP `cashbox_id`;
