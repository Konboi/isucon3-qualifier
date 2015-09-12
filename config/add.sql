ALTER TABLE memos ADD INDEX `is_private_idx` (`is_private`);
ALTER TABLE memos ADD INDEX `user_idx` (`user`);
ALTER TABLE memos ADD username varchar(255) NOT NULL;
