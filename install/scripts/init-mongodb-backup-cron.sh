#!/usr/bin/env sh

# Exit script immediately if a command exits with a non-zero status.
set -e

# Install mongodb-org-tools according to official docs at
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
apt-get update
apt-get install -y apt-transport-https ca-certificates wget gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
apt-get update
apt-get install -y mongodb-org-tools="$MONGODB_VERSION"

# Install and configure cron
apt-get install -y cron
cat /passdeposit/config/crontab.txt | crontab -

# Start cron
echo "Starting cron"
exec /usr/sbin/cron -f
