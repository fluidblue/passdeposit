#
# PassDeposit
# Makefile
#
# Created by Max Geissler
#
#
# PLEASE NOTE:
#  * You need to have installed certain tools for this makefile.
#    Run 'make install-tools' to install all required tools.
#  * npm and gem need to be installed to run 'make install-tools'
#


# Makefile configuration
# ----------------------
SHELL := /bin/bash
PATH := $(PATH):/usr/local/bin
SOURCE_DIR = src
BUILD_DIR = build
BUILD_HTTPDOCS_DIR = $(BUILD_DIR)/httpdocs
BUILD_SERVER_DIR = $(BUILD_DIR)/server


# Main target
# -----------
all: clean css js html media server


# Development target (debug)
# --------------------------
debug: clean css-debug js-debug html media server-debug


# Clean build directory target
# ----------------------------
clean:
	-rm -R ./$(BUILD_DIR)/
	mkdir -p ./$(BUILD_DIR)


# Tool installation target
# ------------------------
install-tools:
	sudo npm install -g webmake-coffee
	sudo npm install -g uglify-js
	sudo npm install -g htmlcat
	sudo gem install sass


# Compile CSS
# -----------
css: css-base
	sass --style compressed ./$(SOURCE_DIR)/css/passdeposit.scss ./$(BUILD_HTTPDOCS_DIR)/css/passdeposit.css

css-debug: css-base
	sass --style expanded ./$(SOURCE_DIR)/css/passdeposit.scss ./$(BUILD_HTTPDOCS_DIR)/css/passdeposit.css

css-base:
	mkdir -p ./$(BUILD_HTTPDOCS_DIR)/css


# Compile JS
# ----------
js: js-base
	webmake --ext=coffee ./$(SOURCE_DIR)/js/passdeposit.coffee ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js

	cat ./$(SOURCE_DIR)/js/license.js > ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.min.js

	uglifyjs ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js >> ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.min.js
	rm ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js
	mv ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.min.js ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js

js-debug: js-base
#	webmake --ext=coffee --sourcemap ./$(SOURCE_DIR)/js/passdeposit.coffee ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js
	webmake --ext=coffee ./$(SOURCE_DIR)/js/passdeposit.coffee ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js

js-base:
	mkdir -p ./$(BUILD_HTTPDOCS_DIR)/js


# Process HTML files
# ------------------
html:
	htmlcat --in ./$(SOURCE_DIR)/html/index.htm --out ./$(BUILD_HTTPDOCS_DIR)/index.htm


# Copy media
# -----------
media:
	cp -R ./$(SOURCE_DIR)/media ./$(BUILD_HTTPDOCS_DIR)


# Compile server
# --------------
server:
	coffee --compile --bare --output ./$(BUILD_SERVER_DIR) ./$(SOURCE_DIR)/js/server

server-debug:
	coffee --compile --bare --map --output ./$(BUILD_SERVER_DIR) ./$(SOURCE_DIR)/js/server
