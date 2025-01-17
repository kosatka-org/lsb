ALTER TABLE `items_measuring` ADD `barcode` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `item_id`, ADD `user_id` INT(11) NOT NULL AFTER `barcode`;
UPDATE items_measuring im SET im.barcode=(SELECT i.barcode FROM items i WHERE i.item_id = im.item_id);
ALTER TABLE `items_measuring` ADD `date` TIMESTAMP NOT NULL AFTER `product_id`;