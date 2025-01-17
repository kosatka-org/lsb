ALTER TABLE  `orders_products` ADD  `barcode` VARCHAR( 32 ) NOT NULL AFTER  `product_id`;

ALTER TABLE  `orders` ADD  `barcode` VARCHAR( 32 ) NOT NULL AFTER  `order_id`;