CREATE TABLE IF NOT EXISTS `goods` (
  `id` int(7) NOT NULL AUTO_INCREMENT,
  `visible` tinyint(1) NOT NULL,
  `position` int(5) NOT NULL,
  `brand_id` int(5) NOT NULL,
  `category_id` int(5) NOT NULL,
  `title` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `meta_title` varchar(255) NOT NULL,
  `meta_keywords` varchar(255) NOT NULL,
  `meta_description` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `annotation` text NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `brand_id` (`brand_id`,`category_id`),
  UNIQUE KEY `url_2` (`url`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;