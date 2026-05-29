TRUNCATE `products`;

TRUNCATE `items`;

TRUNCATE `categories`;

INSERT INTO `categories` (`parent`, `name`, `url`, `gender`) VALUES (0, 'Ювелирные изделия', 'yuvelirnye-izdeliya', 0);

TRUNCATE `brands`;

INSERT INTO `brands` (`name`, `word`, `url`, `gender`, `meta_title`, `meta_keywords`) VALUES ('ADAMAS', 'A', 'adamas', 0, 'Adamas', 'Adamas');

INSERT INTO `brands` (`name`, `word`, `url`, `gender`, `meta_title`, `meta_keywords`) VALUES ('SVETLOV', 'S', 'svetlov', 0, 'Svetlov', 'Svetlov');

TRUNCATE `colors`;
