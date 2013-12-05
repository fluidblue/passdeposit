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
frontPage = require "./gui/pages/front"
mainPage = require "./gui/pages/main"
itemlist = require "./gui/itemlist"
navPills = require "./gui/components/nav-pills"
jGrowl = require "./gui/components/jgrowl-extend"

# Initialize page when DOM is ready.
$(document).ready ->
	navPills.init()
	frontPage.init()
	mainPage.init()
	itemlist.init()
	jGrowl.init()
	
	return
