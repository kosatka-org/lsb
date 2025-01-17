INSERT INTO  `groups` (
`group_id` ,
`name` ,
`discount`
)
VALUES (
'6',  'Бухгалтер',  '10.00'
);
ALTER TABLE  `orders` ADD  `last_update` DATETIME NOT NULL AFTER  `date`;