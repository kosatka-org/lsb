ALTER TABLE `orders` CHANGE `delivery_date` `delivery_date` DATETIME NOT NULL;
ALTER TABLE `orders` CHANGE `agreed_delivery_date` `agreed_delivery_date` DATETIME NOT NULL;
ALTER TABLE `orders` CHANGE `date_to_delivery` `date_to_delivery` DATETIME NOT NULL;
ALTER TABLE `orders` CHANGE `date_to_decline` `date_to_decline` DATETIME NOT NULL;
