#!/usr/bin/env sh

# Exit script immediately if a command exits with a non-zero status.
set -e

# Define log file location
LOG_FILE=/passdeposit/log/passdeposit.log

# Install PassDeposit
npm install --global passdeposit

# Start PassDeposit
passdeposit --config /passdeposit/config/passdeposit.json >> "$LOG_FILE" 2>&1 &

# Output backup log as docker container log
touch "$LOG_FILE"
tail -n 0 -f "$LOG_FILE"
