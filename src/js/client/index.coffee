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

# Require page files
global = require "./gui/global"
front = require "./gui/front"
main = require "./gui/main"

# Initialize page when DOM is ready.
$(document).ready ->
	global.init()
	front.init()
	main.init()
	
	return
