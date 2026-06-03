TRUNCATE `products_fotos`;

CREATE TABLE `svetlov`.`products_downloaded_img`
(
    `product_id` int UNSIGNED NOT NULL,
    `first_img`  varchar(255) NOT NULL,
    `second_img` varchar(255) NULL,
    PRIMARY KEY (`product_id`)
);
