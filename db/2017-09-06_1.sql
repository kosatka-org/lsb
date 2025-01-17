CREATE TABLE `lsboutique`.`expenses` ( `id` INT NOT NULL AUTO_INCREMENT , `cashbox_id` INT NOT NULL , `expense_type` VARCHAR(50) NOT NULL , `sum` FLOAT(10,2) NOT NULL , `comment` TEXT NOT NULL , `date` DATETIME NOT NULL , `user_id` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;

CREATE TABLE `lsboutique`.`inkass` ( `id` INT NOT NULL AUTO_INCREMENT , `cashbox_id` INT NOT NULL , `sum` FLOAT(10,2) NOT NULL , `comment` TEXT NOT NULL , `date` DATETIME NOT NULL , `user_id` INT NOT NULL , `responsible_user_id` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;
