CREATE TABLE `products_location` (
`product_group_id` TINYINT NOT NULL DEFAULT '0',
`location` VARCHAR( 255 ) NOT NULL ,
UNIQUE (
`location`
)
) ENGINE = MYISAM ;

INSERT INTO `products_location` (`location`)
SELECT DISTINCT item_location FROM `products`;


UPDATE `products_location` SET `product_group_id` = '2' WHERE `products_location`.`location` = 'ПОДИУМ#Podium VIP' LIMIT 1 ;
UPDATE `products_location` SET `product_group_id` = '2' WHERE `products_location`.`location` = 'Podium VIP' LIMIT 1 ;
UPDATE `products_location` SET `product_group_id` = '2' WHERE `products_location`.`location` = 'Luxury Store (НВН)#Podium VIP' LIMIT 1 ;
UPDATE `products_location` SET `product_group_id` = '2' WHERE `products_location`.`location` = 'Podium VIP#Luxury Store (НВН)' LIMIT 1 ;
UPDATE `products_location` SET `product_group_id` = '2' WHERE `products_location`.`location` = 'Podium VIP#Luxury Store (Этажи)' LIMIT 1 ;


UPDATE `products_location` SET `product_group_id` = '4' WHERE `products_location`.`location` = 'Out Let' LIMIT 1 ;
UPDATE `products_location` SET `product_group_id` = '4' WHERE `products_location`.`location` = 'Out Let#Luxury Store (Этажи)' LIMIT 1 ;
UPDATE `products_location` SET `product_group_id` = '4' WHERE `products_location`.`location` = 'Luxury Store (НВН)#Out Let' LIMIT 1 ;
UPDATE `products_location` SET `product_group_id` = '4' WHERE `products_location`.`location` = 'Luxury Store (Этажи)#Out Let' LIMIT 1 ;


UPDATE `products_location` SET `product_group_id` = '1' WHERE `products_location`.`location` = 'Luxury Store (НВН)' LIMIT 1; 
UPDATE `products_location` SET `product_group_id` = '1' WHERE `products_location`.`location` = 'Luxury Store (Этажи)' LIMIT 1; 
UPDATE `products_location` SET `product_group_id` = '1' WHERE `products_location`.`location` = 'Ice Iceberg' LIMIT 1; 
UPDATE `products_location` SET `product_group_id` = '1' WHERE `products_location`.`location` = 'Ice Iceberg#Luxury Store (Этажи)#Luxury Store (НВН)' LIMIT 1; 
UPDATE `products_location` SET `product_group_id` = '1' WHERE `products_location`.`location` = 'Ice Iceberg#Luxury Store (Этажи)' LIMIT 1; 
UPDATE `products_location` SET `product_group_id` = '1' WHERE `products_location`.`location` = 'Luxury Store (Этажи)#Luxury Store (НВН)' LIMIT 1;
UPDATE `products_location` SET `product_group_id` = '1' WHERE `products_location`.`location` = 'Luxury Store (НВН)#Luxury Store (Этажи)' LIMIT 1 ;