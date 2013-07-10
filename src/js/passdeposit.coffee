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
initFrontPage = require "./pages/front"
initMainPage = require "./pages/main"
initPopovers = require "./components/init-popovers"
navPills = require "./components/nav-pills"
jGrowl = require "./components/jgrowl-extend"
fields = require "./components/fields"

# Initialize page when DOM is ready.
$(document).ready ->
	initPopovers()
	navPills.init()
	initFrontPage()
	initMainPage()
	jGrowl.init()
	fields.init()
	
	return
