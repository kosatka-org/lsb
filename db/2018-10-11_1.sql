CREATE TABLE `lsboutique`.`work_hours` ( `id` INT NOT NULL , `user_id` INT NOT NULL , `date` DATE NOT NULL , `start` VARCHAR(20) NOT NULL , `end` VARCHAR(20) NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;

ALTER TABLE `work_hours` CHANGE `id` `id` INT(11) NOT NULL AUTO_INCREMENT;
