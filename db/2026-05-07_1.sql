UPDATE `specials` SET enabled = 0;

UPDATE `specials` SET enabled = 1 ORDER BY special_id DESC LIMIT 3;
