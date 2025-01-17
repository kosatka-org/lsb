CREATE TABLE `lsboutique`.`employment` (`id` INT NOT NULL, `name` VARCHAR(300) NOT NULL, `phone` VARCHAR(30) NOT NULL, `position` VARCHAR(100) NOT NULL, `salary` VARCHAR(50) NOT NULL, `age` VARCHAR(50) NOT NULL, `last_job` VARCHAR(300) NOT NULL, `education` VARCHAR(300) NOT NULL, `hours` VARCHAR(50) NOT NULL, `family` VARCHAR(50) NOT NULL, `home_city` VARCHAR(50) NOT NULL, `drivers_license` VARCHAR(50) NOT NULL, `photo` VARCHAR(100) NOT NULL, `date` TIMESTAMP NOT NULL, PRIMARY KEY (`id`)) ENGINE = MyISAM CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE  `employment` ADD  `children` VARCHAR( 100 ) NOT NULL ,
ADD  `citizenship` VARCHAR( 50 ) NOT NULL ,
ADD  `languages` VARCHAR( 50 ) NOT NULL ,
ADD  `skills` VARCHAR( 300 ) NOT NULL ,
ADD  `resume` TEXT NOT NULL;