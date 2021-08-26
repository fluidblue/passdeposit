#!/usr/bin/env sh

# Exit script immediately if a command exits with a non-zero status.
set -e

# Install mongodb-org-tools according to official docs at
# https://docs.mongodb.com/v3.6/tutorial/install-mongodb-on-ubuntu/
apt-get update
apt-get install -y apt-transport-https ca-certificates wget
wget -qO - https://www.mongodb.org/static/pgp/server-3.6.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
apt-get update
apt-get install -y mongodb-org-tools=3.6.9

# Install and setup anacron
apt-get install -y anacron
cat /passdeposit/config/anacrontab.txt >> /etc/anacrontab
service anacron start

# Output backup log as docker container log
tail -n 0 -f /passdeposit/log/backup.log
