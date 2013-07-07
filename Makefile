#
# PassDeposit
# Makefile
#
# Created by Max Geissler
#
#
# PLEASE NOTE:
#  * You need to have installed certain tools for this makefile.
#    Run 'make install' to install all required tools.
#  * npm and gem need to be installed to run 'make install'
#


# Makefile configuration
# ----------------------
SHELL := /bin/bash
PATH := $(PATH):/usr/local/bin
SOURCE_DIR = src
BUILD_DIR = build


# Main target
# -----------
all: clean css js html media


# Development target (debug)
# --------------------------
debug: clean css-debug js-debug html media


# Clean build directory target
# ----------------------------
clean:
	-rm -R ./$(BUILD_DIR)/
	mkdir -p ./$(BUILD_DIR)


# Tool installation target
# ------------------------
install:
	sudo npm install -g webmake-coffee
	sudo npm install -g uglify-js
	sudo gem install sass


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
	webmake --ext=coffee ./$(SOURCE_DIR)/js/passdeposit.coffee ./$(BUILD_DIR)/js/passdeposit.js

	cat ./$(SOURCE_DIR)/js/license.js > ./$(BUILD_DIR)/js/passdeposit.min.js

	uglifyjs ./$(BUILD_DIR)/js/passdeposit.js >> ./$(BUILD_DIR)/js/passdeposit.min.js
	rm ./$(BUILD_DIR)/js/passdeposit.js
	mv ./$(BUILD_DIR)/js/passdeposit.min.js ./$(BUILD_DIR)/js/passdeposit.js

js-debug: js-base
#	webmake --ext=coffee --sourcemap ./$(SOURCE_DIR)/js/passdeposit.coffee ./$(BUILD_DIR)/js/passdeposit.js
	webmake --ext=coffee ./$(SOURCE_DIR)/js/passdeposit.coffee ./$(BUILD_DIR)/js/passdeposit.js

js-base:
	mkdir -p ./$(BUILD_DIR)/js


# Process HTML files
# ------------------
html:
	cp -R ./$(SOURCE_DIR)/html/* ./$(BUILD_DIR)


# Copy media
# -----------
media:
	cp -R ./$(SOURCE_DIR)/media ./$(BUILD_DIR)