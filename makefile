#
# PassDeposit makefile
#
# Authored by Max Geissler
#
#
# PLEASE NOTE:
# * You need to have installed certain tools for this makefile.
#   Run tools-install.sh to install all required tools.
# * This makefile depends on bash. It won't work without bash.
#


# Makefile configuration
# ----------------------
SHELL := /bin/bash
PATH := $(PATH):/usr/local/bin
SOURCE_DIR = src
BUILD_DIR = build


# Main target
# -----------
all: tools-check clean css js html php media


# Development target (debug)
# --------------------------
debug: tools-check clean css-debug js-debug html php media
	

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
	node ./scripts/build-javascript.js ./$(BUILD_DIR)/js/passdeposit.js

js-debug: js-base
	node ./scripts/build-javascript.js ./$(BUILD_DIR)/js/passdeposit.js debug
	
js-base:
	mkdir -p ./$(BUILD_DIR)/js
	cp ./$(SOURCE_DIR)/js/lib/html5shiv.js ./$(BUILD_DIR)/js/


# Process HTML files
# ------------------
html:
	cp -R ./$(SOURCE_DIR)/html/* ./$(BUILD_DIR)


# Copy PHP files
# --------------
php:
	cp -R ./$(SOURCE_DIR)/php ./$(BUILD_DIR)


# Copy media
# -----------
media:
	cp -R ./$(SOURCE_DIR)/media ./$(BUILD_DIR)


# Check if required tools are available
# -------------------------------------
tools-check:
	@./scripts/tools-check.sh


# Clean build directory
# ---------------------
clean:
	-rm -R ./$(BUILD_DIR)/
	mkdir -p ./$(BUILD_DIR)