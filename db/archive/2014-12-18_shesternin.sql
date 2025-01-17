ALTER TABLE  `users` ADD INDEX (  `original_user_id` );

ALTER TABLE  `copywriters_tasks` ADD UNIQUE (`doc_type`, `doc_id`, `field`);