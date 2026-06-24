ALTER TABLE `products`
    ADD COLUMN `local_video` varchar(50) NULL AFTER `stretch`;

ALTER TABLE `products_downloaded_img`
    ADD COLUMN `video` varchar(255) NULL AFTER `extra`;
