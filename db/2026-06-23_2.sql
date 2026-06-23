ALTER TABLE `products_fotos`
    MODIFY COLUMN `product_foto_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT FIRST;

ALTER TABLE `products_fotos`
    MODIFY COLUMN `foto_id` int(11) UNSIGNED NOT NULL DEFAULT 0 AFTER `product_id`;

ALTER TABLE `products_fotos`
    ADD UNIQUE INDEX `product_id-foto_id`(`product_id`, `foto_id`);

ALTER TABLE `products_downloaded_img`
    ADD COLUMN `extra` json NULL AFTER `second_img`;
