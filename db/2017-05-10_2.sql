ALTER TABLE `users` ADD `hidden` TINYINT(1) NOT NULL AFTER `last_api_login_date`, ADD `vip` TINYINT(1) NOT NULL AFTER `hidden`;

CREATE TABLE `lsboutique`.`client_groups` ( `id` INT NOT NULL AUTO_INCREMENT , `name` VARCHAR(100) NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;

CREATE TABLE `lsboutique`.`users_client_groups` ( `user_id` INT NOT NULL , `client_group_id` INT NOT NULL , INDEX (`user_id`), INDEX (`client_group_id`)) ENGINE = InnoDB;

INSERT INTO `client_groups` (`id`, `name`) VALUES (NULL, 'low coster');
INSERT INTO `client_groups` (`id`, `name`) VALUES (NULL, 'big size');
INSERT INTO `client_groups` (`id`, `name`) VALUES (NULL, 'small size');
