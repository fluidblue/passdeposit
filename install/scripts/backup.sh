mongodump --host mongodb --db passdeposit -u passdeposit -p "$(cat /etc/passdeposit/mongodb_initial_passdeposit_password.txt)" --out /var/passdeposit/backup/mongo_backup_$(date +%Y-%m-%d)/
