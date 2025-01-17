ALTER TABLE `products` ADD `video_added` DATETIME NOT NULL;
UPDATE `products` SET `video_added` = `modified` WHERE `video` IS NOT NULL AND TRIM(`video`) <> '';