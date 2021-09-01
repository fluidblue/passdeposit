#!/usr/bin/env sh

# Exit script immediately if a command exits with a non-zero status.
set -e

# Install mongodb-org-tools according to official docs at
# https://docs.mongodb.com/v4.4/tutorial/install-mongodb-on-ubuntu/
apt-get update
apt-get install -y apt-transport-https ca-certificates wget gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install -y mongodb-org-tools="$MONGODB_VERSION"

# Install and configure anacron
apt-get install -y anacron
cat /passdeposit/config/anacrontab.txt >> /etc/anacrontab

# Start anacron
echo "Starting anacron"
exec /usr/sbin/anacron -ds
