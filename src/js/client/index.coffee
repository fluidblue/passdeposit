###
# PassDeposit #
Main Engine

Created by Max Geissler
###

# Require framework
# The framework will attach itself to the window object
require "jquery"
require "jquery-csv"
require "jquery-jgrowl"
require "jquery-total-storage"
require "jquery-wiggle"
require "bootstrap"
require "bootstrap-tag"

# Require GUI
gui = require "./gui"
core = require "./core"

# Initialize GUI when DOM is ready
$(document).ready ->
	gui.init()
	core.init()
	return
