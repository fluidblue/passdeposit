#!/bin/bash

#
# PassDeposit tools check
#
# Authored by Max Geissler
#

# Check if node and sass are available
if ! command -v "node" >/dev/null 2>&1 || ! command -v "sass" >/dev/null 2>&1; then
	echo "ERROR: Required tools are missing. Run scripts/tools-install.sh" 1>&2
	exit 1
fi

# Check if node modules are available
if ! [ -d "node_modules" ] || \
! [ -d "node_modules/browserify" ] || \
! [ -d "node_modules/browserify-shim" ] || \
! [ -d "node_modules/uglify-js" ]; then
	echo "ERROR: Required node modules are missing. Run scripts/tools-install.sh" 1>&2
	exit 1
fi