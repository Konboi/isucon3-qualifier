ALTER TABLE memos ADD INDEX `memos_is_private_created_at_idx` (`is_private`, `created_at`);
ALTER TABLE memos ADD INDEX `memos_user_created_at_idx` (`user`, `created_at`);
ALTER TABLE memos ADD username varchar(255) NOT NULL;
