###
# PassDeposit #
Main page initialization

Created by Max Geissler
###

optionsDialog = require "./options"
donationDialog = require "./donations"
lockDialog = require "./lock"
logout = require "./logout"
btnAdd = require "./btnAdd"
search = require "./search"
itemlist = require "./itemlist"
landingpage = require "./landingpage"

# Initializes main page
init = ->
	optionsDialog.init()
	donationDialog.init()
	lockDialog.init()
	logout.init()
	btnAdd.init()
	search.init()
	itemlist.init()
	landingpage.init()

module.exports.init = init
