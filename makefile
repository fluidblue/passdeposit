#
# PassDeposit makefile
#
# Authored by Max Geissler
#
#
# PLEASE NOTE: You need to have installed the following compilers:
# * requirejs
# * sass
#
# requirejs can be installed by the node.js package manager (npm):
# sudo npm install -g requirejs
#
# sass can be installed by the RubyGems package manager (gem):
# sudo gem install sass
#


# Makefile configuration
# ----------------------
SHELL := /bin/bash
PATH := $(PATH):/usr/local/bin
SOURCE_DIR = src
BUILD_DIR = build



# Main target
# -----------
all: clean css js html php img


# Development target (debug)
# --------------------------
debug: clean css-debug js-debug html php img
	

# Compile CSS
# -----------
css: css-base
	sass --style compressed ./$(SOURCE_DIR)/css/passdeposit.scss ./$(BUILD_DIR)/css/passdeposit.css

css-debug: css-base
	sass --style expanded ./$(SOURCE_DIR)/css/passdeposit.scss ./$(BUILD_DIR)/css/passdeposit.css

css-base:
	mkdir -p ./$(BUILD_DIR)/css


# Compile JS
# ----------
js: js-base
	r.js -o ./$(SOURCE_DIR)/js/passdeposit-build-script.js out=./$(BUILD_DIR)/js/passdeposit.js

js-debug: js-base
	r.js -o ./$(SOURCE_DIR)/js/passdeposit-build-script.js out=./$(BUILD_DIR)/js/passdeposit.js optimize=none

js-base:
	mkdir -p ./$(BUILD_DIR)/js
	cp ./$(SOURCE_DIR)/js/lib/html5shiv.js ./$(BUILD_DIR)/js/


# Copy HTML files
# ---------------
html:
	cp -R ./$(SOURCE_DIR)/html/* ./$(BUILD_DIR)


# Copy PHP files
# --------------
php:
	cp -R ./$(SOURCE_DIR)/php ./$(BUILD_DIR)


# Copy images
# -----------
img:
	cp -R ./$(SOURCE_DIR)/img ./$(BUILD_DIR)


# Clean build directory
# ---------------------
clean:
	-rm -R ./$(BUILD_DIR)/
	mkdir -p ./$(BUILD_DIR)