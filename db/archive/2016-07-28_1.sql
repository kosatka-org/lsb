ALTER TABLE  `banners` ADD  `user_level` INT NOT NULL DEFAULT  '1' COMMENT  '1 - всем, 2 - только зарегистрированным, 3 - имеющим оплаченные покупки';
