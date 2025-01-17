ALTER TABLE `categories` CHANGE `size_type_id` `mens_size_type_id` INT(8) NOT NULL;
ALTER TABLE `categories` ADD `womens_size_type_id` INT(8) NOT NULL AFTER `canonical_id`;
