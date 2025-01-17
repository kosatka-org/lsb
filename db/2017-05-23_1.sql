ALTER TABLE `calls_log` ADD `manager_id` INT NOT NULL AFTER `status`, ADD INDEX (`manager_id`);
