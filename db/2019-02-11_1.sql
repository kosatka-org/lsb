INSERT INTO `subgroups` (`subgroup_id`, `group_id`, `name`) VALUES (NULL, '13', 'Старший');
UPDATE `users` SET `subgroup_id` = 4 WHERE `user_id` IN (9722,128822,131068,131359);