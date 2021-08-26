#!/usr/bin/env sh

# Exit script immediately if a command exits with a non-zero status.
set -e

# Install PassDeposit
npm install --global passdeposit

# Start PassDeposit
passdeposit --config /etc/passdeposit/passdeposit.json
