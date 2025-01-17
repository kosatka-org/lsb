CREATE TABLE IF NOT EXISTS `subgroups` (
  `subgroup_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`subgroup_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `subgroups` (`subgroup_id`,`group_id`,`name`)
VALUES 
(NULL,'5','Онлайн'),
(NULL,'5','Оффлайн'),
(NULL,'5','Кладощик');

