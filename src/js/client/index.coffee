###
# PassDeposit #

Created by Max Geissler
###

# Require framework
# The framework will attach itself to the window object
require "jquery"
require "jquery-jgrowl"
require "jquery-total-storage"
require "bootstrap"
require "bootstrap-tag"

# Require GUI
gui = require "./gui"

# Initialize GUI when DOM is ready
$(document).ready ->
	gui.init()
	return
