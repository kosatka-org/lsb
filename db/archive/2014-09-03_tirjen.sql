ALTER TABLE `goods` ADD `text_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `text`;

ALTER TABLE `goods` ADD `editor_id` INT( 8 ) UNSIGNED NOT NULL AFTER `text_modified`;