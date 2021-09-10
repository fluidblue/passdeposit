#!/usr/bin/env sh

# Exit script immediately if a command exits with a non-zero status.
set -e

# Install PassDeposit
npm install --global passdeposit

# Start PassDeposit and log output
echo "Starting PassDeposit..."
exec passdeposit --config /passdeposit/config/passdeposit.json
