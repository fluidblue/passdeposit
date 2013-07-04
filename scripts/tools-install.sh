#!/bin/bash

#
# PassDeposit tool installation
#
# Created by Max Geissler
#

# Go to main directory
cd ..

# Check if node is available
if ! command -v "node" >/dev/null 2>&1; then
	echo "node needs to be installed. See http://nodejs.org/ for installation." 1>&2
	exit 1
fi

# Check if npm is available
if ! command -v "npm" >/dev/null 2>&1; then
	echo "npm (node package manager) needs to be installed. See http://nodejs.org/ for installation." 1>&2
	exit 1
fi

# Install sass
if ! command -v "sass" >/dev/null 2>&1; then
	if command -v "gem" >/dev/null 2>&1; then
		sudo gem install sass
	else
		echo "Could not install sass. See http://sass-lang.com/ for manual installation."
		exit 1
	fi
fi

# Install required node modules
echo "Installing node modules to $(pwd)/node_modules"
npm install browserify
npm install browserify-shim
npm install uglify-js

# Finished
echo "Successfully installed tools."