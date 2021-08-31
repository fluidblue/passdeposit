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
BUILD_SHARED_DIR = $(BUILD_SERVER_DIR)/shared
BUILD_MSG_DIR = $(BUILD_SERVER_DIR)/msg


# Main target
# -----------
all: clean css js html media server package msg


# Development target (debug)
# --------------------------
debug: clean css-debug js-debug html media server-debug package msg


# Clean build directory target
# ----------------------------
clean:
	-rm -R ./$(BUILD_DIR)/
	mkdir -p ./$(BUILD_DIR)


# Tool installation target
# ------------------------
install-tools:
	sudo npm install -g coffee-script
	sudo npm install -g webmake
	sudo npm install -g webmake-coffee
	sudo npm install -g uglify-js
	sudo npm install -g htmlcat
	sudo npm install -g sass


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

define js_dist

cat ./$(SOURCE_DIR)/js/license.js > $1.min.js

uglifyjs $1 >> $1.min.js
rm $1
mv $1.min.js $1

endef

js: js-base
	webmake --ext=coffee --ignore-errors ./$(SOURCE_DIR)/js/client/index.coffee ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js
	webmake --ext=coffee --ignore-errors ./$(SOURCE_DIR)/js/client/worker/index.coffee ./$(BUILD_HTTPDOCS_DIR)/js/worker.js

	$(call js_dist,./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js)
	$(call js_dist,./$(BUILD_HTTPDOCS_DIR)/js/worker.js)

js-debug: js-base
#	webmake --ext=coffee --ignore-errors --sourcemap ./$(SOURCE_DIR)/js/client/index.coffee ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js
	webmake --ext=coffee --ignore-errors ./$(SOURCE_DIR)/js/client/index.coffee ./$(BUILD_HTTPDOCS_DIR)/js/passdeposit.js

#	webmake --ext=coffee --ignore-errors --sourcemap ./$(SOURCE_DIR)/js/client/worker/index.coffee ./$(BUILD_HTTPDOCS_DIR)/js/worker.js
	webmake --ext=coffee --ignore-errors ./$(SOURCE_DIR)/js/client/worker/index.coffee ./$(BUILD_HTTPDOCS_DIR)/js/worker.js

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
	coffee --compile --bare --output ./$(BUILD_SHARED_DIR) ./$(SOURCE_DIR)/js/shared

server-debug:
	coffee --compile --bare --map --output ./$(BUILD_SERVER_DIR) ./$(SOURCE_DIR)/js/server
	coffee --compile --bare --map --output ./$(BUILD_SHARED_DIR) ./$(SOURCE_DIR)/js/shared


# Copy messages
# -------------
msg:
	cp -R ./$(SOURCE_DIR)/msg ./$(BUILD_MSG_DIR)


# Copy package data
# -----------------
package:
	cp ./$(SOURCE_DIR)/npm/* ./$(BUILD_DIR)/
	cp *.md ./$(BUILD_DIR)/
