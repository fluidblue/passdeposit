#!/usr/bin/env sh

# Exit script immediately if a command exits with a non-zero status.
set -e

# Define log file location
LOG_FILE=/passdeposit/log/passdeposit.log

# Install PassDeposit
npm install --global passdeposit

# Start PassDeposit and log output
echo "Starting PassDeposit. Log file location: $LOG_FILE"
exec passdeposit --config /passdeposit/config/passdeposit.json 2>&1 >> "$LOG_FILE"
