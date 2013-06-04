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
# sudo npm install -g <packagename>
#
# sass can be installed by the RubyGems package manager (gem):
# sudo gem install sass
#


# Makefile configuration
# ----------------------
SOURCE_DIR = src
BUILD_DIR = build


# Main target
# -----------
all: clean css js html php img


# Compile CSS
# -----------
css:
	mkdir -p ./$(BUILD_DIR)/css
	sass --style compressed ./$(SOURCE_DIR)/css/passdeposit.scss ./$(BUILD_DIR)/css/passdeposit.css


# Compile JS
# ----------
# Take configuration for requirejs from JS build script
js:
	mkdir -p ./$(BUILD_DIR)/js
	r.js -o ./$(SOURCE_DIR)/js/passdeposit-build-script.js out=./$(BUILD_DIR)/js/passdeposit.js
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
	rm -Rf ./$(BUILD_DIR)/
	mkdir -p ./$(BUILD_DIR)