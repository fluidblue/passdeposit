#!/usr/bin/env sh

mongodump \
	--host mongodb \
	--db passdeposit \
	-u passdeposit \
	-p "$(cat /passdeposit/config/mongodb_initial_passdeposit_password.txt)" \
	--out /passdeposit/backup/mongo_backup_$(date +%Y-%m-%d)/
