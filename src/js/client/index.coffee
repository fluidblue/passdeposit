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

# Require initialization files
frontPage = require "./gui/front"
mainPage = require "./gui/main"
navPills = require "./gui/global/nav-pills"
jGrowl = require "./gui/global/jgrowl-extend"

# Initialize page when DOM is ready.
$(document).ready ->
	navPills.init()
	frontPage.init()
	mainPage.init()
	jGrowl.init()
	
	return
