CREATE TABLE  `services_items` (
`id` INT NOT NULL AUTO_INCREMENT ,
`name` VARCHAR( 200 ) NOT NULL ,
`price` INT NOT NULL ,
`time` INT NOT NULL ,
`type` VARCHAR( 50 ) NOT NULL ,
PRIMARY KEY (  `id` )
) ENGINE = MYISAM ;

CREATE TABLE  `services_orders` (
`id` INT NOT NULL AUTO_INCREMENT ,
`date` TIMESTAMP NOT NULL ,
`client_id` INT( 20 ) NOT NULL ,
`client_info` VARCHAR( 300 ) NOT NULL ,
`comment` VARCHAR( 500 ) NOT NULL ,
PRIMARY KEY (  `id` )
) ENGINE = MYISAM ;

CREATE TABLE  `services_orders_items` (
`id` INT NOT NULL AUTO_INCREMENT ,
`order_id` INT NOT NULL ,
`item_id` INT NOT NULL ,
PRIMARY KEY (  `id` )
) ENGINE = MYISAM ;

ALTER TABLE  `orders_products` ADD  `new_order` TINYINT( 1 ) NOT NULL DEFAULT  '1';