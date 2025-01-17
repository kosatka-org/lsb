CREATE TABLE `stories` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `eng_title` varchar(150) NOT NULL,
  `banner` varchar(150) NOT NULL,
  `eng_banner` varchar(150) NOT NULL,
  `position` tinyint(3) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `url` varchar(150) NOT NULL,
  `create_date` timestamp NOT NULL,
  `end_date` date NOT NULL,
  `block_1` varchar(150) NOT NULL,
  `block_2` varchar(150) NOT NULL,
  `block_3` varchar(150) NOT NULL,
  `block_4` varchar(150) NOT NULL,
  `block_5` varchar(150) NOT NULL,
  `block_6` varchar(150) NOT NULL,
  `block_7` varchar(150) NOT NULL,
  `block_8` varchar(150) NOT NULL,
  `block_9` varchar(150) NOT NULL,
  `block_10` varchar(150) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE `stories`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `stories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;