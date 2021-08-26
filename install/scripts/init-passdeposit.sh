#!/usr/bin/env sh

# Exit script immediately if a command exits with a non-zero status.
set -e

# Define log file location
LOG_FILE=/passdeposit/log/passdeposit.log

# Install PassDeposit
npm install --global passdeposit

# Start PassDeposit and log output
exec passdeposit --config /passdeposit/config/passdeposit.json 2>&1 | tee -a "$LOG_FILE"
