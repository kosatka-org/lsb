CREATE TABLE  `lsboutique`.`users2shops` (
`user_id` INT NOT NULL ,
`shop` VARCHAR( 300 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
INDEX (  `user_id` )
) ENGINE = MYISAM ;