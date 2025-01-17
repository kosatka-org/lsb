ALTER TABLE `users` ADD `uid` VARCHAR( 16 ) NOT NULL AFTER `name` ,
ADD `photo` VARCHAR( 255 ) NOT NULL AFTER `uid` ,
ADD `photo_rec` VARCHAR( 255 ) NOT NULL AFTER `photo`;

ALTER TABLE `users` ADD UNIQUE (
`email`
);