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
frontPage = require "./pages/front"
mainPage = require "./pages/main"
navPills = require "./components/nav-pills"
jGrowl = require "./components/jgrowl-extend"

# Initialize page when DOM is ready.
$(document).ready ->
	navPills.init()
	frontPage.init()
	mainPage.init()
	jGrowl.init()
	
	return
