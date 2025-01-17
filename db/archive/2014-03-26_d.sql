CREATE TABLE  `lsboutique`.`users_calls_incoming` (
`call_id` INT( 10 ) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`date` TIMESTAMP NOT NULL ,
`phone` VARCHAR( 100 ) NOT NULL ,
`duration` INT( 16 ) NOT NULL
) ENGINE = MYISAM ;

ALTER TABLE  `users_calls_incoming` CHANGE  `phone`  `phone` VARCHAR( 100 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL